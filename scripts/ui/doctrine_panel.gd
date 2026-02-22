## DoctrinePanel — Overlay panel showing the doctrine research tree.
## Organizes doctrines by tier and lets the player research them with RP.
## Opened from CommandHQ via the "Research Doctrines" button.
class_name DoctrinePanel
extends PanelContainer


# --- Constants ---

const DOCTRINE_CARD_SCENE: String = "res://scenes/ui/DoctrineCard.tscn"


# --- Node References ---

@onready var close_btn: Button = $MarginContainer/VBox/TopBar/CloseButton
@onready var rp_label: Label = $MarginContainer/VBox/TopBar/RPLabel
@onready var tree_container: VBoxContainer = $MarginContainer/VBox/ScrollArea/TreeContainer
@onready var status_label: Label = $MarginContainer/VBox/StatusLabel


# --- State ---

## All available doctrines, loaded once.
var _all_doctrines: Array[DoctrineData] = []

## References to all DoctrineCard instances for refreshing.
var _cards: Array = []


# --- Lifecycle ---

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

	close_btn.pressed.connect(_on_close_pressed)
	EventBus.resource_changed.connect(_on_resource_changed)


# --- Public Functions ---

## Opens the panel and builds the doctrine tree.
func show_panel(doctrines: Array[DoctrineData]) -> void:
	_all_doctrines = doctrines
	_build_tree()
	_refresh_rp()
	_set_status("Select a doctrine to research.")
	visible = true


## Hides the panel.
func hide_panel() -> void:
	visible = false


# --- Signal Callbacks ---

## Closes the panel.
func _on_close_pressed() -> void:
	hide_panel()


## Updates the RP display when resources change.
func _on_resource_changed(resource_type: String, _new_value: int) -> void:
	if resource_type == "requisition_points":
		_refresh_rp()
		_refresh_all_cards()


## Called when a DoctrineCard requests research.
func _on_research_requested(data: DoctrineData) -> void:
	# Check prerequisites.
	for prereq_id in data.prerequisites:
		if not DoctrineManager.is_researched(prereq_id):
			_set_status("Cannot research: prerequisite '%s' not met." % prereq_id)
			return

	# Try to spend RP.
	if not ResourceManager.spend("requisition_points", data.cost_rp):
		_set_status("Not enough Requisition Points! Need %d RP." % data.cost_rp)
		return

	# Research the doctrine.
	DoctrineManager.research(data.id)
	_set_status("'%s' researched!" % data.display_name)
	_refresh_all_cards()


# --- Private Functions ---

## Builds the full tree UI, organized by tier.
func _build_tree() -> void:
	# Clear existing content.
	for child in tree_container.get_children():
		child.queue_free()
	_cards.clear()

	# Group doctrines by tier.
	var tiers: Dictionary = {}
	for doctrine in _all_doctrines:
		if not tiers.has(doctrine.tier):
			tiers[doctrine.tier] = []
		tiers[doctrine.tier].append(doctrine)

	# Sort tier keys and build each tier section.
	var tier_keys: Array = tiers.keys()
	tier_keys.sort()

	for tier_num in tier_keys:
		_build_tier_section(tier_num, tiers[tier_num])


## Creates a tier header and doctrine cards for one tier level.
func _build_tier_section(tier_num: int, doctrines: Array) -> void:
	# Tier header.
	var header := Label.new()
	header.text = "— Tier %d —" % tier_num
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tree_container.add_child(header)

	# Horizontal row of doctrine cards.
	var row := HBoxContainer.new()
	row.theme_override_constants = {}
	row.add_theme_constant_override("separation", 12)
	tree_container.add_child(row)

	# Load card scene and create one per doctrine.
	if not ResourceLoader.exists(DOCTRINE_CARD_SCENE):
		push_warning("DoctrinePanel: DoctrineCard.tscn not found.")
		return

	var card_scene: PackedScene = load(DOCTRINE_CARD_SCENE)
	for doctrine in doctrines:
		var card: DoctrineCard = card_scene.instantiate()
		row.add_child(card)
		card.init_card(doctrine)
		card.research_requested.connect(_on_research_requested)
		_cards.append(card)

	# Spacer between tiers.
	var spacer := HSeparator.new()
	tree_container.add_child(spacer)


## Refreshes all doctrine cards (e.g. after a research or RP change).
func _refresh_all_cards() -> void:
	for card in _cards:
		card.refresh()


## Updates the RP label in the top bar.
func _refresh_rp() -> void:
	rp_label.text = "RP: %d" % ResourceManager.get_amount("requisition_points")


## Sets the status text at the bottom.
func _set_status(text: String) -> void:
	status_label.text = text
