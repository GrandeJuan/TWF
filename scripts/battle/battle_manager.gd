## BattleManager — Core script that orchestrates the trench battle simulation.
## Handles starting/pausing battles, spawning units, checking win/loss, and triggering events.
class_name BattleManager
extends Node


# --- State ---

## Whether the battle is currently paused.
var is_paused: bool = false

## Whether a battle is currently running.
var is_battle_active: bool = false

## The FrontData resource for the current battle.
var current_front_data: Resource = null


# --- Node References ---
# These point to the unit container nodes in TrenchBattle.tscn.

## Container node that holds all human unit instances.
@onready var human_forces: Node2D = $"../HumanForces"

## Container node that holds all Grakk unit instances.
@onready var grakk_forces: Node2D = $"../GrakkForces"


# --- Lifecycle ---

func _ready() -> void:
	# Pause processing until a battle is explicitly started.
	set_process(false)


func _process(_delta: float) -> void:
	if not is_battle_active or is_paused:
		return

	# TODO: Run per-frame battle simulation logic here.
	check_battle_end()


# --- Public Functions ---

## Initializes and starts a battle using the given front data.
func start_battle(front_data: Resource) -> void:
	current_front_data = front_data
	is_battle_active = true
	is_paused = false
	set_process(true)

	spawn_human_units()
	spawn_grakk_wave()

	EventBus.battle_started.emit(front_data)
	print("BattleManager: Battle started.")


## Pauses the battle simulation. Time stops for all units.
func pause_battle() -> void:
	is_paused = true
	get_tree().paused = true
	print("BattleManager: Battle paused.")


## Resumes the battle simulation after a pause.
func resume_battle() -> void:
	is_paused = false
	get_tree().paused = false
	print("BattleManager: Battle resumed.")


## Spawns human units into the HumanForces container based on front data.
func spawn_human_units() -> void:
	# TODO: Read assigned units from current_front_data.
	# TODO: Instantiate Unit.tscn for each and add to human_forces.
	pass


## Spawns a wave of Grakk units into the GrakkForces container.
func spawn_grakk_wave() -> void:
	# TODO: Determine wave composition based on tier and enemy pressure.
	# TODO: Instantiate Unit.tscn for each and add to grakk_forces.
	pass


## Checks whether the battle has ended in victory or defeat.
func check_battle_end() -> void:
	# TODO: Victory condition — all Grakk units defeated or repelled.
	# TODO: Defeat condition — human trench line overrun (all human units dead/routed).
	var humans_alive := human_forces.get_child_count()
	var grakks_alive := grakk_forces.get_child_count()

	if grakks_alive == 0 and is_battle_active:
		_end_battle("victory")
	elif humans_alive == 0 and is_battle_active:
		_end_battle("defeat")


## Triggers a random battle event (EU4-style popup).
func trigger_battle_event() -> void:
	# TODO: Ask EventManager to trigger a battle-phase event.
	EventManager.trigger_random_event()


# --- Private Functions ---

## Ends the battle and emits the result signal.
func _end_battle(result: String) -> void:
	is_battle_active = false
	set_process(false)
	EventBus.battle_ended.emit(result)
	print("BattleManager: Battle ended — %s." % result)
