## FrontData — Resource representing a single battle front on the map.
## Tracks which units, supplies, and doctrines are assigned to this front.
## Stored in GameState.active_fronts and passed to BattleManager to start battles.
class_name FrontData
extends Resource


## Unique identifier for this front (e.g. "outer_ruins_north").
@export var id: String = ""

## Display name shown on the map (e.g. "Outer Ruins — North Sector").
@export var name: String = ""

## Which tier this front belongs to. 1-4 early, 0 isthmus, -1 offensive.
@export var tier: int = 1

## Enemy pressure level from 1 (low) to 4 (critical).
@export var enemy_pressure: int = 1

## Array of UnitData resources assigned to this front by the player.
@export var assigned_units: Array = []

## Amount of supplies allocated to this front.
@export var assigned_supplies: int = 0

## Array of doctrine IDs active on this front.
@export var active_doctrines: Array = []

## Current status: "active", "won", or "lost".
@export var status: String = "active"


## Returns a human-readable label for the enemy pressure level.
func get_pressure_label() -> String:
	match enemy_pressure:
		1: return "Low"
		2: return "Medium"
		3: return "High"
		4: return "Critical"
		_: return "Unknown"
