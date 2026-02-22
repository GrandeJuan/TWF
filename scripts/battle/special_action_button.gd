## SpecialActionButton — A button with cooldown timer and limited uses.
## Used in the BattleHUD for special actions like Artillery Strike.
class_name SpecialActionButton
extends Button


# --- Signals ---

## Emitted when the player activates this special action.
signal action_activated(action_id: String)


# --- Configuration ---

## Unique identifier for this action (e.g. "artillery_strike").
@export var action_id: String = ""

## Display name shown on the button.
@export var action_name: String = "Action"

## Cooldown duration in seconds after each use.
@export var cooldown_duration: float = 30.0

## Maximum number of uses per battle. -1 = unlimited.
@export var max_uses: int = 1


# --- Runtime State ---

## How many uses remain in this battle.
var uses_remaining: int = 1

## Time left on the current cooldown (0 = ready).
var cooldown_remaining: float = 0.0

## Whether the action is currently on cooldown.
var is_on_cooldown: bool = false


# --- Node References ---

@onready var cooldown_label: Label = $CooldownLabel


# --- Lifecycle ---

func _ready() -> void:
	uses_remaining = max_uses
	pressed.connect(_on_pressed)
	_update_display()


func _process(delta: float) -> void:
	if not is_on_cooldown:
		return

	cooldown_remaining -= delta
	if cooldown_remaining <= 0.0:
		cooldown_remaining = 0.0
		is_on_cooldown = false

	_update_display()


# --- Public Functions ---

## Resets the button for a new battle.
func reset_action() -> void:
	uses_remaining = max_uses
	cooldown_remaining = 0.0
	is_on_cooldown = false
	_update_display()


# --- Private Functions ---

## Called when the player clicks the button.
func _on_pressed() -> void:
	if is_on_cooldown or uses_remaining == 0:
		return

	# Spend a use (if not unlimited).
	if max_uses > 0:
		uses_remaining -= 1

	# Start cooldown.
	cooldown_remaining = cooldown_duration
	is_on_cooldown = true

	action_activated.emit(action_id)
	_update_display()


## Updates the button text and disabled state.
func _update_display() -> void:
	disabled = is_on_cooldown or uses_remaining == 0

	if uses_remaining == 0 and max_uses > 0:
		text = "%s\n(NO USES)" % action_name
	elif is_on_cooldown:
		text = "%s\n(%ds)" % [action_name, int(ceil(cooldown_remaining))]
	elif max_uses > 0:
		text = "%s\n[%d]" % [action_name, uses_remaining]
	else:
		text = action_name

	if cooldown_label:
		cooldown_label.visible = is_on_cooldown
		if is_on_cooldown:
			cooldown_label.text = "%ds" % int(ceil(cooldown_remaining))
