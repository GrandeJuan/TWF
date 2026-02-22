## Main — Entry point scene script. Manages phase transitions.
## Listens to EventBus.phase_changed and swaps the active phase scene accordingly.
class_name Main
extends Node


# --- Scene Paths ---
# Paths to each phase scene. These match the layout defined in ARCHITECTURE.md.

const SCENE_BASE: String = "res://scenes/base/CommandHQ.tscn"
const SCENE_MAP: String = "res://scenes/map/WorldMap.tscn"
const SCENE_BATTLE: String = "res://scenes/battle/TrenchBattle.tscn"


# --- Node References ---

## Container node where the current phase scene is loaded as a child.
@onready var phase_container: Node = $PhaseContainer

## The currently loaded phase scene instance (so we can free it on transition).
var _current_phase_scene: Node = null


# --- Lifecycle ---

func _ready() -> void:
	# Connect to the global phase_changed signal from EventBus.
	EventBus.phase_changed.connect(_on_phase_changed)

	# Start the game in the base phase.
	_change_phase("base")


# --- Phase Management ---

## Called when EventBus emits phase_changed. Triggers the scene swap.
func _on_phase_changed(new_phase: String) -> void:
	_change_phase(new_phase)


## Unloads the current phase scene and loads the new one.
func _change_phase(new_phase: String) -> void:
	# Update GameState so all systems know the current phase.
	GameState.current_phase = new_phase

	# Remove the old phase scene if one exists.
	if _current_phase_scene != null:
		phase_container.remove_child(_current_phase_scene)
		_current_phase_scene.queue_free()
		_current_phase_scene = null

	# Determine which scene to load based on the phase name.
	var scene_path := _get_scene_path(new_phase)
	if scene_path.is_empty():
		push_error("Main: Unknown phase '%s' — cannot load scene." % new_phase)
		return

	# Check if the scene file exists before trying to load it.
	if not ResourceLoader.exists(scene_path):
		push_warning("Main: Scene '%s' does not exist yet. Phase '%s' skipped." % [scene_path, new_phase])
		return

	# Load and instantiate the phase scene.
	var packed_scene: PackedScene = load(scene_path)
	_current_phase_scene = packed_scene.instantiate()
	phase_container.add_child(_current_phase_scene)

	print("Main: Phase changed to '%s'." % new_phase)


## Returns the scene file path for a given phase name.
func _get_scene_path(phase: String) -> String:
	match phase:
		"base":
			return SCENE_BASE
		"map":
			return SCENE_MAP
		"battle":
			return SCENE_BATTLE
		_:
			return ""
