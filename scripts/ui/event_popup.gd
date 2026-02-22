## EventPopup — EU4/CK-style event card popup.
## Displays an event title, flavor text, and 2-3 choice buttons.
## Listens to EventBus.event_triggered to show events.
## Pauses the battle while visible so the player can read and decide.
class_name EventPopup
extends PanelContainer


# --- Signals ---

## Emitted when the player makes a choice. Carries event ID and choice index.
signal choice_made(event_id: String, choice_index: int)


# --- Node References ---

@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleLabel
@onready var separator: HSeparator = $MarginContainer/VBoxContainer/Separator
@onready var flavor_label: RichTextLabel = $MarginContainer/VBoxContainer/FlavorText
@onready var choices_container: VBoxContainer = $MarginContainer/VBoxContainer/ChoicesContainer


# --- State ---

## The EventData currently being displayed.
var _current_event: EventData = null


# --- Lifecycle ---

func _ready() -> void:
	# Start hidden. Events show the popup when triggered.
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

	# Listen for events from the global EventBus.
	EventBus.event_triggered.connect(_on_event_triggered)


# --- Public Functions ---

## Shows the popup with the given EventData.
func show_event(event_data: EventData) -> void:
	_current_event = event_data

	# Fill in the card content.
	title_label.text = event_data.title
	flavor_label.text = event_data.flavor_text

	# Clear old choice buttons and create new ones.
	_clear_choices()
	_create_choice_buttons(event_data.choices)

	# Show the popup and pause the battle so the player can decide.
	visible = true
	get_tree().paused = true


## Hides the popup and resumes the game.
func hide_event() -> void:
	visible = false
	_current_event = null
	get_tree().paused = false


# --- Private Functions ---

## Called when EventBus emits event_triggered.
func _on_event_triggered(event_data: Resource) -> void:
	var data := event_data as EventData
	if data == null:
		push_warning("EventPopup: Received non-EventData resource.")
		return
	show_event(data)


## Removes all existing choice buttons from the container.
func _clear_choices() -> void:
	for child in choices_container.get_children():
		child.queue_free()


## Creates a button for each choice in the event.
func _create_choice_buttons(choices: Array[Dictionary]) -> void:
	for i in range(choices.size()):
		var choice: Dictionary = choices[i]
		var btn := Button.new()
		btn.text = _format_choice_label(i, choice)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.custom_minimum_size.y = 36

		# Capture the index for the lambda.
		var index := i
		btn.pressed.connect(func(): _on_choice_selected(index))

		choices_container.add_child(btn)


## Formats a choice button label: "A) Choice text here"
func _format_choice_label(index: int, choice: Dictionary) -> String:
	var letter := char(65 + index)  # 65 = 'A'
	var text: String = choice.get("text", "???")
	return "%s) %s" % [letter, text]


## Called when the player clicks a choice button.
func _on_choice_selected(index: int) -> void:
	if _current_event == null:
		return

	var event_id := _current_event.id
	choice_made.emit(event_id, index)

	# Tell EventManager to apply the consequences.
	EventManager.resolve_event(event_id, index)

	# Close the popup and resume play.
	hide_event()
