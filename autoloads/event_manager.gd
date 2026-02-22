## EventManager — Handles random and scripted event generation and resolution.
## Accessible from any script via the autoload name "EventManager".
extends Node


# --- Public Functions ---

## Triggers a random event appropriate for the current phase.
## Selects from the available event pool and emits the event via EventBus.
func trigger_random_event() -> void:
	# TODO: Build event pool filtering by current phase, tier, and conditions.
	# TODO: Pick a weighted random event and call trigger_event() with its ID.
	pass


## Triggers a specific event by its ID.
## Loads the EventData and emits EventBus.event_triggered.
func trigger_event(event_id: String) -> void:
	# TODO: Load EventData resource from data/ folder by event_id.
	# TODO: Emit EventBus.event_triggered(event_data).
	pass


## Resolves an event after the player picks a choice.
## Applies the consequences of the chosen option.
func resolve_event(event_id: String, choice_index: int) -> void:
	# TODO: Look up the event's choice by index.
	# TODO: Apply each consequence in the choice's consequences array.
	pass
