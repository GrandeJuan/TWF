## EventBus — Global signal hub for decoupled cross-system communication.
## Any script can emit or connect to these signals via the autoload name "EventBus".
extends Node


# --- Phase Signals ---

## Emitted when the game transitions to a new phase ("base", "map", "battle").
signal phase_changed(new_phase: String)

# --- Battle Signals ---

## Emitted when a battle begins on a specific front.
signal battle_started(front_data: Resource)

## Emitted when a battle ends. Result is "victory" or "defeat".
signal battle_ended(result: String)

## Emitted when a unit is destroyed (health reached 0).
signal unit_destroyed(unit: Node)

## Emitted when a unit's morale breaks. Result is "broken" or "inspired".
signal unit_morale_break(unit: Node, result: String)

# --- Event Signals ---

## Emitted when a narrative event is triggered (base or battle phase).
signal event_triggered(event_data: Resource)

# --- Doctrine Signals ---

## Emitted when a doctrine is successfully researched.
signal doctrine_researched(doctrine_id: String)

## Emitted when a doctrine is activated during battle.
signal doctrine_activated(doctrine_id: String)

# --- Resource Signals ---

## Emitted when any resource value changes (manpower, supplies, requisition_points).
signal resource_changed(resource_type: String, new_value: int)
