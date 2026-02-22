## CommandHQ — Base phase scene script.
## The player manages resources, researches doctrines, recruits units,
## handles events, and reviews intel before proceeding to the Map phase.
class_name CommandHQ
extends Control


# --- Node References: Resource Display ---

@onready var manpower_value: Label = $MainLayout/TopBar/ManpowerValue
@onready var supplies_value: Label = $MainLayout/TopBar/SuppliesValue
@onready var rp_value: Label = $MainLayout/TopBar/RPValue

# --- Node References: Intel Panel ---

@onready var tier_label: Label = $MainLayout/ContentArea/IntelPanel/TierLabel
@onready var fronts_list: VBoxContainer = $MainLayout/ContentArea/IntelPanel/FrontsList

# --- Node References: Action Buttons ---

@onready var research_btn: Button = $MainLayout/ContentArea/ActionsPanel/ResearchButton
@onready var recruit_btn: Button = $MainLayout/ContentArea/ActionsPanel/RecruitButton
@onready var intel_btn: Button = $MainLayout/ContentArea/ActionsPanel/IntelButton
@onready var proceed_btn: Button = $MainLayout/ContentArea/ActionsPanel/ProceedButton

# --- Node References: Status ---

@onready var status_label: Label = $MainLayout/StatusBar/StatusLabel


# --- Lifecycle ---

func _ready() -> void:
	# Connect action buttons.
	research_btn.pressed.connect(_on_research_pressed)
	recruit_btn.pressed.connect(_on_recruit_pressed)
	intel_btn.pressed.connect(_on_intel_pressed)
	proceed_btn.pressed.connect(_on_proceed_pressed)

	# Listen to resource changes to keep the display updated.
	EventBus.resource_changed.connect(_on_resource_changed)

	# Initialize displays.
	_refresh_resources()
	_refresh_intel()
	_set_status("Command HQ ready. Awaiting orders, General Commissar.")


# --- Signal Callbacks ---

## Updates a single resource label when it changes.
func _on_resource_changed(resource_type: String, new_value: int) -> void:
	match resource_type:
		"manpower":
			manpower_value.text = str(new_value)
		"supplies":
			supplies_value.text = str(new_value)
		"requisition_points":
			rp_value.text = str(new_value)


## Opens the doctrine research panel.
func _on_research_pressed() -> void:
	# TODO: Show DoctrinePanel overlay with available doctrines.
	_set_status("Doctrine research panel not yet available.")


## Opens the unit recruitment panel.
func _on_recruit_pressed() -> void:
	# TODO: Show recruitment panel with available unit types and costs.
	_set_status("Unit recruitment panel not yet available.")


## Refreshes the intel display with latest front data.
func _on_intel_pressed() -> void:
	_refresh_intel()
	_set_status("Intel updated.")


## Transitions to the Map phase.
func _on_proceed_pressed() -> void:
	_set_status("Moving to World Map...")
	EventBus.phase_changed.emit("map")


# --- Private Functions ---

## Reads current values from ResourceManager and updates all labels.
func _refresh_resources() -> void:
	manpower_value.text = str(ResourceManager.get_amount("manpower"))
	supplies_value.text = str(ResourceManager.get_amount("supplies"))
	rp_value.text = str(ResourceManager.get_amount("requisition_points"))


## Updates the intel panel with current tier and active fronts.
func _refresh_intel() -> void:
	# Show the current war tier.
	var tier_text := _get_tier_name(GameState.current_tier)
	tier_label.text = "Current Theater: %s" % tier_text

	# Clear and rebuild the fronts list.
	for child in fronts_list.get_children():
		child.queue_free()

	if GameState.active_fronts.is_empty():
		var empty_label := Label.new()
		empty_label.text = "No active fronts."
		fronts_list.add_child(empty_label)
		return

	for front in GameState.active_fronts:
		var front_label := Label.new()
		front_label.text = "- %s  [Pressure: %d]  [%s]" % [
			front.name, front.enemy_pressure, front.status
		]
		fronts_list.add_child(front_label)


## Returns a readable name for the current war tier.
func _get_tier_name(tier: int) -> String:
	match tier:
		1: return "Tier 1 — The Outer Ruins"
		2: return "Tier 2 — The Ash Fields"
		3: return "Tier 3 — The Iron Ridges"
		4: return "Tier 4 — The Gate of Ferro"
		0: return "The Ferro Isthmus"
		-1: return "The Offensive"
		_: return "Unknown"


## Sets the status bar text at the bottom of the screen.
func _set_status(text: String) -> void:
	status_label.text = text
