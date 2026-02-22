# ARCHITECTURE.md — TWF: The Last Trench of Veranthos IV

## Engine & Language
- **Godot 4.6.1**
- **GDScript only** (no C#)
- **Renderer:** Compatibility (2D)

---

## Scene Structure

### Top-Level Scenes
```
Main.tscn               ← Entry point. Manages phase transitions.
scenes/
  base/
    CommandHQ.tscn      ← Base phase: resource management, research, events
  map/
    WorldMap.tscn       ← Map phase: front assignment, troop deployment
  battle/
    TrenchBattle.tscn   ← Battle phase: side-scrolling simulation
  ui/
    HUD.tscn            ← In-battle HUD (resources, actions, pause button)
    EventPopup.tscn     ← EU4-style event card popup
    DoctrinePanel.tscn  ← Doctrine activation panel
    MainMenu.tscn       ← Main menu
  shared/
    Unit.tscn           ← Base unit scene (human and grakk inherit from this)
    HealthBar.tscn      ← Reusable health/morale bar component
```

---

## Autoloads (Global Singletons)

These are loaded at game start and accessible from any script.

### GameState (autoloads/game_state.gd)
Tracks overall game progress and current phase.
```gdscript
var current_phase: String  # "base", "map", "battle"
var current_tier: int      # 1-4 early, 0 = isthmus, -1 = offensive
var active_fronts: Array   # List of active FrontData resources
var game_won: bool
var game_lost: bool
```

### EventBus (autoloads/event_bus.gd)
Global signal hub. All cross-system communication goes through here.
```gdscript
signal phase_changed(new_phase: String)
signal battle_started(front_data: Resource)
signal battle_ended(result: String)  # "victory", "defeat", "stalemate"
signal event_triggered(event_data: Resource)
signal doctrine_activated(doctrine_id: String)
signal resource_changed(resource_type: String, new_value: int)
```

### ResourceManager (autoloads/resource_manager.gd)
Manages the three core resources.
```gdscript
var manpower: int
var supplies: int
var requisition_points: int

func spend(type: String, amount: int) -> bool
func gain(type: String, amount: int) -> void
func get_amount(type: String) -> int
```

### DoctrineManager (autoloads/doctrine_manager.gd)
Tracks research state and active doctrines.
```gdscript
var researched: Array[String]
var active_in_battle: Array[String]

func research(doctrine_id: String) -> bool
func activate(doctrine_id: String) -> void
func deactivate(doctrine_id: String) -> void
func is_researched(doctrine_id: String) -> bool
```

### EventManager (autoloads/event_manager.gd)
Handles event generation and resolution.
```gdscript
func trigger_random_event() -> void
func trigger_event(event_id: String) -> void
func resolve_event(event_id: String, choice_index: int) -> void
```

---

## Data Architecture

Game data is stored as **Godot Resources** (.tres files) or **JSON** files in the `data/` folder.

### FrontData (data model)
Represents a single battle front on the map.
```
id: String
name: String
tier: int
enemy_pressure: int       # 1-4
assigned_units: Array
assigned_supplies: int
active_doctrines: Array
status: String            # "active", "won", "lost"
```

### UnitData (data model)
Represents a unit type definition.
```
id: String
display_name: String
faction: String           # "human" or "grakk"
health: int
damage: int
speed: float
morale: int
sprite_path: String
```

### DoctrineData (data model)
Represents a researchable doctrine.
```
id: String
display_name: String
description: String
cost_rp: int
prerequisites: Array[String]
effect_type: String       # "passive", "active", "unlock"
```

### EventData (data model)
Represents a scripted or random event.
```
id: String
title: String
flavor_text: String
phase: String             # "base" or "battle"
choices: Array[Dictionary]
  # choice = { "text": String, "consequences": Array[Dictionary] }
```

---

## Battle System Architecture

### TrenchBattle.tscn Node Tree
```
TrenchBattle (Node2D)
  Background (ParallaxBackground)
  Terrain (Node2D)
    TrenchLine (StaticBody2D)
    Obstacles (Node2D)
  HumanForces (Node2D)    ← Container for all human units
  GrakkForces (Node2D)    ← Container for all grakk units
  BattleHUD (CanvasLayer)
    HUD.tscn instance
  EventLayer (CanvasLayer)
    EventPopup.tscn instance
  BattleManager (Node)    ← Script that runs battle logic
```

### BattleManager (scripts/battle/battle_manager.gd)
Core script that orchestrates the battle simulation.
```gdscript
func start_battle(front_data: FrontData) -> void
func pause_battle() -> void
func resume_battle() -> void
func spawn_human_units() -> void
func spawn_grakk_wave() -> void
func check_battle_end() -> void
func trigger_battle_event() -> void
```

### Unit State Machine
Each unit uses a simple state machine:
- `IDLE` → waiting for orders or targets
- `ADVANCE` → moving toward enemy (Grakks always, Humans in late game)
- `HOLD` → holding position and firing
- `RETREAT` → morale broken, moving backward
- `DEAD` → removed from simulation

---

## Phase Transition Flow

```
Main.tscn
  └── loads CommandHQ.tscn (Base phase)
        └── player finishes → GameState.current_phase = "map"
              └── loads WorldMap.tscn (Map phase)
                    └── player confirms deployment → GameState.current_phase = "battle"
                          └── loads TrenchBattle.tscn for each active front
                                └── all battles resolved → back to Base phase
```

Phase transitions are handled by `Main.tscn` listening to `EventBus.phase_changed`.

---

## Development Order (Recommended Build Sequence)

Build in this order to always have something playable:

1. **Autoloads** — GameState, EventBus, ResourceManager (skeleton versions)
2. **TrenchBattle** — get a basic battle running with placeholder units
3. **Unit system** — state machine, movement, combat
4. **BattleHUD** — pause button, resource display, special actions
5. **EventPopup** — EU4-style event cards
6. **CommandHQ** — base phase with resource management
7. **WorldMap** — front assignment
8. **DoctrineManager + DoctrinePanel** — research tree
9. **Data files** — fill in all units, doctrines, events
10. **Polish** — art, audio, animations, balance
