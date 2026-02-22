## DoctrineCard — UI card for a single doctrine in the research tree.
## Shows name, cost, description, prerequisites, and a research button.
class_name DoctrineCard
extends PanelContainer


# --- Signals ---

## Emitted when the player clicks "Research" on this card.
signal research_requested(doctrine_data: DoctrineData)


# --- Node References ---

@onready var name_label: Label = $VBox/NameLabel
@onready var type_label: Label = $VBox/Header/TypeLabel
@onready var cost_label: Label = $VBox/Header/CostLabel
@onready var desc_label: Label = $VBox/DescLabel
@onready var prereq_label: Label = $VBox/PrereqLabel
@onready var research_btn: Button = $VBox/ResearchButton
@onready var status_label: Label = $VBox/StatusLabel


# --- State ---

## The DoctrineData this card represents.
var doctrine_data: DoctrineData = null


# --- Public Functions ---

## Initializes the card from a DoctrineData resource.
func init_card(data: DoctrineData) -> void:
	doctrine_data = data
	research_btn.pressed.connect(_on_research_pressed)
	refresh()


## Refreshes the card display based on current research state.
func refresh() -> void:
	if doctrine_data == null:
		return

	name_label.text = doctrine_data.display_name
	type_label.text = "[%s]" % doctrine_data.effect_type.to_upper()
	cost_label.text = "%d RP" % doctrine_data.cost_rp
	desc_label.text = doctrine_data.description

	# Show prerequisites if any.
	if doctrine_data.prerequisites.is_empty():
		prereq_label.text = "Requires: None"
	else:
		prereq_label.text = "Requires: %s" % ", ".join(doctrine_data.prerequisites)

	# Update state: researched, available, or locked.
	var is_researched := DoctrineManager.is_researched(doctrine_data.id)
	var prereqs_met := _check_prerequisites()
	var can_afford := ResourceManager.get_amount("requisition_points") >= doctrine_data.cost_rp

	if is_researched:
		status_label.text = "RESEARCHED"
		status_label.add_theme_color_override("font_color", Color.GREEN)
		research_btn.visible = false
	elif not prereqs_met:
		status_label.text = "LOCKED"
		status_label.add_theme_color_override("font_color", Color.DARK_GRAY)
		research_btn.visible = false
	else:
		status_label.text = ""
		research_btn.visible = true
		research_btn.disabled = not can_afford
		if not can_afford:
			research_btn.text = "Not enough RP"
		else:
			research_btn.text = "Research (%d RP)" % doctrine_data.cost_rp


# --- Private Functions ---

## Returns true if all prerequisite doctrines have been researched.
func _check_prerequisites() -> bool:
	for prereq_id in doctrine_data.prerequisites:
		if not DoctrineManager.is_researched(prereq_id):
			return false
	return true


## Called when the player clicks the research button.
func _on_research_pressed() -> void:
	research_requested.emit(doctrine_data)
