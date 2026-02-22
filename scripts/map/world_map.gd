## WorldMap — Map phase scene script.
## Shows all active fronts and lets the player assign units, supplies,
## and doctrines before confirming deployment and starting battles.
class_name WorldMap
extends Control


# --- Constants ---

const FRONT_PANEL_SCENE: String = "res://scenes/map/FrontPanel.tscn"


# --- Node References ---

@onready var tier_label: Label = $MainLayout/TopBar/TierLabel
@onready var manpower_value: Label = $MainLayout/TopBar/ManpowerValue
@onready var supplies_value: Label = $MainLayout/TopBar/SuppliesValue
@onready var fronts_container: HBoxContainer = $MainLayout/FrontsArea/FrontsContainer
@onready var deploy_btn: Button = $MainLayout/BottomBar/DeployButton
@onready var back_btn: Button = $MainLayout/BottomBar/BackButton
@onready var status_label: Label = $MainLayout/BottomBar/StatusLabel


# --- State ---

## List of FrontPanel instances, one per active front.
var _front_panels: Array = []


# --- Lifecycle ---

func _ready() -> void:
	deploy_btn.pressed.connect(_on_deploy_pressed)
	back_btn.pressed.connect(_on_back_pressed)

	EventBus.resource_changed.connect(_on_resource_changed)

	_refresh_resources()
	_build_front_panels()
	_update_tier_label()
	_set_status("Assign troops and supplies, then confirm deployment.")


# --- Signal Callbacks ---

## Updates resource labels when they change.
func _on_resource_changed(resource_type: String, new_value: int) -> void:
	match resource_type:
		"manpower":
			manpower_value.text = str(new_value)
		"supplies":
			supplies_value.text = str(new_value)


## Returns to the Base phase without starting battles.
func _on_back_pressed() -> void:
	EventBus.phase_changed.emit("base")


## Confirms deployment and transitions to the Battle phase.
func _on_deploy_pressed() -> void:
	# Check that at least one active front has units assigned.
	var has_deployment := false
	for front in GameState.active_fronts:
		if front.status == "active" and front.assigned_units.size() > 0:
			has_deployment = true
			break

	if not has_deployment:
		_set_status("WARNING: No units deployed to any active front!")
		return

	_set_status("Deploying forces...")
	EventBus.phase_changed.emit("battle")


# --- Private Functions ---

## Reads current values from ResourceManager and updates labels.
func _refresh_resources() -> void:
	manpower_value.text = str(ResourceManager.get_amount("manpower"))
	supplies_value.text = str(ResourceManager.get_amount("supplies"))


## Shows the current war tier in the top bar.
func _update_tier_label() -> void:
	match GameState.current_tier:
		1: tier_label.text = "WORLD MAP — Tier 1: The Outer Ruins"
		2: tier_label.text = "WORLD MAP — Tier 2: The Ash Fields"
		3: tier_label.text = "WORLD MAP — Tier 3: The Iron Ridges"
		4: tier_label.text = "WORLD MAP — Tier 4: The Gate of Ferro"
		0: tier_label.text = "WORLD MAP — The Ferro Isthmus"
		-1: tier_label.text = "WORLD MAP — The Offensive"
		_: tier_label.text = "WORLD MAP"


## Creates a FrontPanel for each active front in GameState.
func _build_front_panels() -> void:
	# Clear any existing panels.
	for child in fronts_container.get_children():
		child.queue_free()
	_front_panels.clear()

	if GameState.active_fronts.is_empty():
		var empty := Label.new()
		empty.text = "No active fronts. Return to Command HQ."
		fronts_container.add_child(empty)
		return

	# Create a panel for each front.
	if not ResourceLoader.exists(FRONT_PANEL_SCENE):
		push_warning("WorldMap: FrontPanel.tscn not found. Using placeholder labels.")
		_build_placeholder_panels()
		return

	var panel_scene: PackedScene = load(FRONT_PANEL_SCENE)
	for front in GameState.active_fronts:
		if front.status != "active":
			continue
		var panel: FrontPanel = panel_scene.instantiate()
		fronts_container.add_child(panel)
		panel.init_panel(front)
		_front_panels.append(panel)


## Fallback: creates simple labels if FrontPanel.tscn doesn't exist yet.
func _build_placeholder_panels() -> void:
	for front in GameState.active_fronts:
		if front.status != "active":
			continue
		var label := Label.new()
		label.text = "%s — Pressure: %s — Units: %d" % [
			front.name, front.get_pressure_label(), front.assigned_units.size()
		]
		fronts_container.add_child(label)


## Sets the status bar text.
func _set_status(text: String) -> void:
	status_label.text = text
