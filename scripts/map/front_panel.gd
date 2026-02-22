## FrontPanel — UI component for a single front on the World Map.
## Shows front status and lets the player assign units, supplies, and doctrines.
class_name FrontPanel
extends PanelContainer


# --- Signals ---

## Emitted when the player changes the supply allocation for this front.
signal supplies_changed(front: FrontData, new_amount: int)

## Emitted when the player assigns or removes a unit from this front.
signal units_changed(front: FrontData)


# --- Node References ---

@onready var front_name_label: Label = $VBox/Header/FrontName
@onready var pressure_label: Label = $VBox/Header/PressureLabel
@onready var status_label: Label = $VBox/Header/StatusLabel
@onready var units_list: VBoxContainer = $VBox/UnitsSection/UnitsList
@onready var units_count_label: Label = $VBox/UnitsSection/UnitsHeader/UnitsCount
@onready var supplies_slider: HSlider = $VBox/SupplySection/SupplySlider
@onready var supplies_value_label: Label = $VBox/SupplySection/SupplyValue
@onready var doctrines_label: Label = $VBox/DoctrinesLabel


# --- State ---

## The FrontData this panel is displaying.
var front_data: FrontData = null


# --- Public Functions ---

## Initializes the panel from a FrontData resource.
func init_panel(data: FrontData) -> void:
	front_data = data
	_refresh_display()

	supplies_slider.value_changed.connect(_on_supplies_slider_changed)


## Refreshes all displayed values from front_data.
func refresh() -> void:
	_refresh_display()


# --- Private Functions ---

## Updates all labels and controls from front_data.
func _refresh_display() -> void:
	if front_data == null:
		return

	front_name_label.text = front_data.name
	pressure_label.text = "Pressure: %s" % front_data.get_pressure_label()
	status_label.text = "[%s]" % front_data.status.to_upper()

	# Color the pressure label based on severity.
	match front_data.enemy_pressure:
		1: pressure_label.add_theme_color_override("font_color", Color.GREEN)
		2: pressure_label.add_theme_color_override("font_color", Color.YELLOW)
		3: pressure_label.add_theme_color_override("font_color", Color.ORANGE)
		4: pressure_label.add_theme_color_override("font_color", Color.RED)

	_refresh_units()
	_refresh_supplies()
	_refresh_doctrines()


## Rebuilds the assigned units list.
func _refresh_units() -> void:
	for child in units_list.get_children():
		child.queue_free()

	units_count_label.text = "%d units" % front_data.assigned_units.size()

	if front_data.assigned_units.is_empty():
		var empty := Label.new()
		empty.text = "  No units assigned."
		units_list.add_child(empty)
		return

	for unit_data in front_data.assigned_units:
		var label := Label.new()
		label.text = "  - %s" % unit_data.display_name
		units_list.add_child(label)


## Updates the supply slider and label.
func _refresh_supplies() -> void:
	supplies_slider.value = front_data.assigned_supplies
	supplies_value_label.text = str(front_data.assigned_supplies)


## Updates the active doctrines display.
func _refresh_doctrines() -> void:
	if front_data.active_doctrines.is_empty():
		doctrines_label.text = "Doctrines: None"
	else:
		doctrines_label.text = "Doctrines: %s" % ", ".join(front_data.active_doctrines)


## Called when the player adjusts the supply slider.
func _on_supplies_slider_changed(value: float) -> void:
	var amount := int(value)
	front_data.assigned_supplies = amount
	supplies_value_label.text = str(amount)
	supplies_changed.emit(front_data, amount)
