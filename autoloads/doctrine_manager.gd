## DoctrineManager — Tracks researched doctrines and which ones are active in battle.
## Accessible from any script via the autoload name "DoctrineManager".
extends Node


# --- State Variables ---

## List of doctrine IDs that have been researched (permanently unlocked).
var researched: Array[String] = []

## List of doctrine IDs currently active during the battle phase.
var active_in_battle: Array[String] = []


# --- Public Functions ---

## Attempts to research a doctrine by its ID.
## Returns true if successfully researched, false if already researched.
func research(doctrine_id: String) -> bool:
	if is_researched(doctrine_id):
		push_warning("DoctrineManager: Doctrine '%s' is already researched." % doctrine_id)
		return false

	researched.append(doctrine_id)
	EventBus.doctrine_researched.emit(doctrine_id)
	return true


## Activates a researched doctrine for the current battle.
func activate(doctrine_id: String) -> void:
	if not is_researched(doctrine_id):
		push_warning("DoctrineManager: Cannot activate '%s' — not researched." % doctrine_id)
		return
	if doctrine_id in active_in_battle:
		return

	active_in_battle.append(doctrine_id)
	EventBus.doctrine_activated.emit(doctrine_id)


## Deactivates a doctrine, removing it from the active battle list.
func deactivate(doctrine_id: String) -> void:
	active_in_battle.erase(doctrine_id)


## Returns true if a doctrine has been researched.
func is_researched(doctrine_id: String) -> bool:
	return doctrine_id in researched
