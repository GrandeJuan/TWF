## UnitStats — Manages a unit's runtime stats: health, morale, and supply.
## Handles damage, morale loss, supply drain, and the Morale Break Event.
## Attached as a child node of Unit.
class_name UnitStats
extends Node


# --- Signals ---

## Emitted when health reaches 0. The unit should transition to DEAD.
signal health_depleted

## Emitted when morale reaches 0. Carries the break result: "broken" or "inspired".
signal morale_broken(result: String)

## Emitted when supply runs out completely.
signal supply_empty

## Emitted whenever any stat changes, for UI updates.
signal stats_changed


# --- Max Values (set from UnitData on init) ---

var max_health: int = 100
var max_morale: int = 100
var max_supply: int = 100


# --- Current Values ---

var health: int = 100
var morale: int = 100
var supply: int = 100


# --- Supply Drain ---

## How much supply drains per second during battle.
@export var supply_drain_rate: float = 1.0


# --- Morale Break ---

## Chance (0.0 to 1.0) that a morale break results in INSPIRED instead of BROKEN.
## Default 20%. Doctrines and special characters can increase this.
var inspire_chance: float = 0.2

## Whether the unit is currently in an inspired state (temporary buff).
var is_inspired: bool = false


# --- Public Functions ---

## Initializes stats from a UnitData resource.
func init_from_data(data: UnitData) -> void:
	max_health = data.health
	max_morale = data.morale
	max_supply = data.supply
	health = max_health
	morale = max_morale
	supply = max_supply


## Applies damage to health. Emits health_depleted if health reaches 0.
func take_damage(amount: int) -> void:
	# Supply level affects resistance: less supply = more damage taken.
	var effective_damage := int(amount * _get_damage_taken_multiplier())
	health = max(health - effective_damage, 0)
	stats_changed.emit()

	if health <= 0:
		health_depleted.emit()


## Reduces morale by the given amount. Triggers Morale Break Event at 0.
func lose_morale(amount: int) -> void:
	morale = max(morale - amount, 0)
	stats_changed.emit()

	if morale <= 0:
		_resolve_morale_break()


## Restores morale by the given amount, clamped to max.
func restore_morale(amount: int) -> void:
	morale = min(morale + amount, max_morale)
	stats_changed.emit()


## Drains supply over time. Called each frame with delta.
func drain_supply(delta: float) -> void:
	supply = max(supply - int(supply_drain_rate * delta * 10.0), 0)
	stats_changed.emit()

	if supply <= 0:
		supply_empty.emit()


## Returns the damage output multiplier based on current supply ratio.
## Full supply = 1.0, low = 0.6, empty = 0.3.
func get_damage_multiplier() -> float:
	var ratio := _get_supply_ratio()
	if ratio >= 0.5:
		return 1.0
	elif ratio >= 0.2:
		return 0.6
	else:
		return 0.3


# --- Private Functions ---

## Returns the supply ratio (0.0 to 1.0).
func _get_supply_ratio() -> float:
	if max_supply <= 0:
		return 0.0
	return float(supply) / float(max_supply)


## Returns the damage-taken multiplier based on supply. Less supply = take more damage.
## Full supply = 1.0 (normal), low = 1.4 (40% more), empty = 2.0 (double).
func _get_damage_taken_multiplier() -> float:
	var ratio := _get_supply_ratio()
	if ratio >= 0.5:
		return 1.0
	elif ratio >= 0.2:
		return 1.4
	else:
		return 2.0


## Resolves the Morale Break Event: BROKEN or INSPIRED.
func _resolve_morale_break() -> void:
	var roll := randf()

	if roll < inspire_chance:
		# INSPIRED — unit rallies against the odds.
		is_inspired = true
		morale = int(max_morale * 0.4)
		stats_changed.emit()
		morale_broken.emit("inspired")
	else:
		# BROKEN — unit routes and retreats.
		morale_broken.emit("broken")
