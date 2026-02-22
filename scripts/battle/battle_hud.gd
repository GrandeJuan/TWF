## BattleHUD — In-battle heads-up display.
## Shows resources, pause button, and special action buttons with cooldowns.
## Must be set to process_mode ALWAYS so the pause button works while paused.
class_name BattleHUD
extends Control


# --- Node References ---

## Resource labels in the top bar.
@onready var manpower_value: Label = $TopBar/ManpowerValue
@onready var supplies_value: Label = $TopBar/SuppliesValue
@onready var rp_value: Label = $TopBar/RPValue

## Pause button in the top bar.
@onready var pause_button: Button = $TopBar/PauseButton

## Special action buttons in the bottom bar.
@onready var artillery_btn: SpecialActionButton = $BottomBar/ArtilleryStrike
@onready var reinforcements_btn: SpecialActionButton = $BottomBar/Reinforcements
@onready var commissar_btn: SpecialActionButton = $BottomBar/CommissarOrder

## Reference to the BattleManager (found at runtime via the scene tree).
var battle_manager: BattleManager = null


# --- Lifecycle ---

func _ready() -> void:
	# This node must keep processing even when the tree is paused.
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Find BattleManager in the scene tree (sibling of BattleHUD CanvasLayer).
	battle_manager = get_parent().get_parent().get_node_or_null("BattleManager")

	# Connect UI signals.
	pause_button.pressed.connect(_on_pause_pressed)
	artillery_btn.action_activated.connect(_on_special_action)
	reinforcements_btn.action_activated.connect(_on_special_action)
	commissar_btn.action_activated.connect(_on_special_action)

	# Connect EventBus signals for resource updates.
	EventBus.resource_changed.connect(_on_resource_changed)
	EventBus.battle_started.connect(_on_battle_started)
	EventBus.battle_ended.connect(_on_battle_ended)

	# Initialize resource display with current values.
	_refresh_all_resources()


# --- Signal Callbacks ---

## Toggles pause on/off via BattleManager.
func _on_pause_pressed() -> void:
	if battle_manager == null:
		return

	if battle_manager.is_paused:
		battle_manager.resume_battle()
		pause_button.text = "PAUSE"
	else:
		battle_manager.pause_battle()
		pause_button.text = "RESUME"


## Called when a special action button is activated.
func _on_special_action(action_id: String) -> void:
	# TODO: Wire each action to its gameplay effect via BattleManager.
	match action_id:
		"artillery_strike":
			print("BattleHUD: Artillery Strike activated!")
		"reinforcements":
			print("BattleHUD: Emergency Reinforcements activated!")
		"commissar_order":
			print("BattleHUD: Commissar's Order activated!")


## Updates a single resource label when it changes.
func _on_resource_changed(resource_type: String, new_value: int) -> void:
	match resource_type:
		"manpower":
			manpower_value.text = str(new_value)
		"supplies":
			supplies_value.text = str(new_value)
		"requisition_points":
			rp_value.text = str(new_value)


## Resets HUD state when a new battle starts.
func _on_battle_started(_front_data: Resource) -> void:
	pause_button.text = "PAUSE"
	artillery_btn.reset_action()
	reinforcements_btn.reset_action()
	commissar_btn.reset_action()


## Disables actions when the battle ends.
func _on_battle_ended(_result: String) -> void:
	artillery_btn.disabled = true
	reinforcements_btn.disabled = true
	commissar_btn.disabled = true


# --- Private Functions ---

## Reads current values from ResourceManager and updates all labels.
func _refresh_all_resources() -> void:
	manpower_value.text = str(ResourceManager.get_amount("manpower"))
	supplies_value.text = str(ResourceManager.get_amount("supplies"))
	rp_value.text = str(ResourceManager.get_amount("requisition_points"))
