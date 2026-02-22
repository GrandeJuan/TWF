# CLAUDE.md — TWF: The Last Trench of Veranthos IV

## Project Overview
This is a 2D strategy game built in **Godot 4.6** using **GDScript**.
The developer is not a professional programmer. Code must be clean, well-commented, and broken into small, manageable pieces. Always explain what you are doing and why.

## Tech Stack
- Engine: Godot 4.6.1
- Language: GDScript
- Renderer: Compatibility (2D only)
- Version Control: Git / GitHub

## Project Structure
```
res://
  scenes/
    base/         ← Command Base phase scenes
    map/          ← World Map phase scenes
    battle/       ← Trench Battle phase scenes
    ui/           ← HUD, menus, popups
    shared/       ← Reusable scene components
  scripts/
    base/
    map/
    battle/
    systems/      ← Core systems (resources, events, doctrines)
    utils/        ← Helper functions and autoloads
  assets/
    sprites/
      units/
      enemies/
      terrain/
      ui/
    audio/
      sfx/
      music/
    fonts/
  data/           ← JSON or GDScript data files (units, doctrines, events)
  autoloads/      ← Global singletons (GameState, EventBus, ResourceManager)
```

## Coding Conventions
- Use **PascalCase** for class names and scene root nodes
- Use **snake_case** for variables, functions, and file names
- Every script must have a `class_name` declaration
- Every public function must have a comment explaining what it does
- Keep scripts under 200 lines. If longer, split into smaller scripts
- Use signals for communication between nodes — avoid direct node references where possible
- Autoloads are used for global state only. Don't abuse them

## Core Autoloads (Singletons)
- `GameState` — tracks current phase, active tier, resources, and game progress
- `EventBus` — global signal bus for decoupled communication between systems
- `ResourceManager` — manages manpower, supplies, requisition points
- `DoctrineManager` — tracks researched and available doctrines
- `EventManager` — handles random and scripted event generation

## Game Phases
The game has three phases that loop: **Base → Map → Battle**
1. **Base (Command HQ):** Resource management, doctrine research, event handling
2. **Map:** Assign troops and resources to active fronts
3. **Battle:** 2D side-scrolling simulation. Humans on the right, Grakks from the left

## Important Design Rules
- Time in battle is pausable at any moment
- Multiple battles can run simultaneously in early/mid game (player manages all)
- The player never directly controls units — they set strategy and react to events
- Doctrines, events, and special actions (e.g. artillery strike) are the player's tools in battle

## Progression Structure
- **Early Game:** 4 tiers of trenches, multiple simultaneous battles per tier
- **Mid Game:** The Ferro Isthmus — one massive single battle
- **Late Game:** Humanity on the offensive, attacking Grakk trenches

## Do NOT Do
- Do not use C# — GDScript only
- Do not create monolithic scripts — keep systems separated
- Do not hardcode values — use data files or exported variables
- Do not reference nodes by path string if avoidable — use signals or dependency injection
