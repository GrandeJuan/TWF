## ResourceManager — Manages the three core resources: manpower, supplies, requisition points.
## Accessible from any script via the autoload name "ResourceManager".
extends Node


# --- Resource Variables ---

## Available soldiers for assignment to fronts.
var manpower: int = 0

## Ammunition, food, and fuel for maintaining front lines.
var supplies: int = 0

## Currency for purchasing upgrades, units, and doctrines.
var requisition_points: int = 0


# --- Public Functions ---

## Attempts to spend a given amount of a resource type.
## Returns true if the spend was successful, false if not enough resources.
func spend(type: String, amount: int) -> bool:
	var current := get_amount(type)
	if current < amount:
		return false

	match type:
		"manpower":
			manpower -= amount
		"supplies":
			supplies -= amount
		"requisition_points":
			requisition_points -= amount
		_:
			push_warning("ResourceManager: Unknown resource type '%s'" % type)
			return false

	EventBus.resource_changed.emit(type, get_amount(type))
	return true


## Adds a given amount to a resource type.
func gain(type: String, amount: int) -> void:
	match type:
		"manpower":
			manpower += amount
		"supplies":
			supplies += amount
		"requisition_points":
			requisition_points += amount
		_:
			push_warning("ResourceManager: Unknown resource type '%s'" % type)
			return

	EventBus.resource_changed.emit(type, get_amount(type))


## Returns the current amount of a resource type.
func get_amount(type: String) -> int:
	match type:
		"manpower":
			return manpower
		"supplies":
			return supplies
		"requisition_points":
			return requisition_points
		_:
			push_warning("ResourceManager: Unknown resource type '%s'" % type)
			return 0
