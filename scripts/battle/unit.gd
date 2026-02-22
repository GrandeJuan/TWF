## Unit — Main unit script. Handles the state machine, movement, and combat.
## Both human and Grakk units use this same script, configured via UnitData.
class_name Unit
extends CharacterBody2D


# --- State Machine ---

enum State { IDLE, ADVANCE, HOLD, RETREAT, DEAD }

## The unit's current state.
var current_state: State = State.IDLE


# --- Configuration ---

## The UnitData resource this unit was spawned from.
var unit_data: UnitData = null

## Which direction the unit advances: -1 = left (humans attacking), 1 = right (grakks attacking).
var advance_direction: int = 1

## Range in pixels at which this unit can attack enemies.
@export var attack_range: float = 150.0

## Seconds between each attack.
@export var attack_cooldown: float = 1.0


# --- Runtime ---

## Timer tracking cooldown between attacks.
var _attack_timer: float = 0.0

## Reference to the UnitStats child node.
@onready var stats: UnitStats = $UnitStats

## Reference to the Sprite2D child node.
@onready var sprite: Sprite2D = $Sprite2D


# --- Lifecycle ---

func _ready() -> void:
	# Connect to UnitStats signals.
	stats.health_depleted.connect(_on_health_depleted)
	stats.morale_broken.connect(_on_morale_broken)
	stats.supply_empty.connect(_on_supply_empty)


func _physics_process(delta: float) -> void:
	if current_state == State.DEAD:
		return

	# Drain supply over time while the unit is alive.
	stats.drain_supply(delta)

	# Tick the attack cooldown.
	if _attack_timer > 0.0:
		_attack_timer -= delta

	# Run the current state's behavior.
	match current_state:
		State.IDLE:
			_process_idle()
		State.ADVANCE:
			_process_advance(delta)
		State.HOLD:
			_process_hold()
		State.RETREAT:
			_process_retreat(delta)


# --- Public Functions ---

## Initializes the unit from a UnitData resource and a direction.
## Call this right after instantiating the Unit scene.
func init_unit(data: UnitData, direction: int) -> void:
	unit_data = data
	advance_direction = direction
	stats.init_from_data(data)

	# Flip sprite to face the advance direction.
	sprite.flip_h = (direction == 1)

	# Set initial state based on faction behavior.
	if data.faction == "grakk":
		# Grakks always advance toward the enemy.
		_change_state(State.ADVANCE)
	else:
		# Humans hold position by default (defensive).
		_change_state(State.HOLD)


## Orders the unit to advance (used in late game for human offensive).
func order_advance() -> void:
	if current_state != State.DEAD and current_state != State.RETREAT:
		_change_state(State.ADVANCE)


## Orders the unit to hold position.
func order_hold() -> void:
	if current_state != State.DEAD and current_state != State.RETREAT:
		_change_state(State.HOLD)


# --- State Behaviors ---

## IDLE: Look for enemies. If found, switch to HOLD or ADVANCE.
func _process_idle() -> void:
	var target := _find_nearest_enemy()
	if target != null:
		if unit_data.faction == "grakk":
			_change_state(State.ADVANCE)
		else:
			_change_state(State.HOLD)


## ADVANCE: Move toward the enemy side. Attack if an enemy is in range.
func _process_advance(delta: float) -> void:
	var target := _find_nearest_enemy()

	if target != null and _distance_to(target) <= attack_range:
		_try_attack(target)
	else:
		# Move in the advance direction.
		velocity.x = unit_data.speed * advance_direction
		move_and_slide()


## HOLD: Stay in position and fire at enemies in range.
func _process_hold() -> void:
	velocity.x = 0
	var target := _find_nearest_enemy()

	if target != null and _distance_to(target) <= attack_range:
		_try_attack(target)


## RETREAT: Move away from the enemy. Unit is broken and cannot fight.
func _process_retreat(delta: float) -> void:
	velocity.x = unit_data.speed * -advance_direction
	move_and_slide()


# --- Combat ---

## Attempts to attack a target if the cooldown has expired.
func _try_attack(target: Unit) -> void:
	if _attack_timer > 0.0:
		return

	var effective_damage := int(unit_data.damage * stats.get_damage_multiplier())

	# Inspired units deal 50% more damage.
	if stats.is_inspired:
		effective_damage = int(effective_damage * 1.5)

	target.stats.take_damage(effective_damage)
	_attack_timer = attack_cooldown


## Finds the nearest enemy unit by checking the opposing force container.
func _find_nearest_enemy() -> Unit:
	var enemy_container := _get_enemy_container()
	if enemy_container == null:
		return null

	var closest: Unit = null
	var closest_dist: float = INF

	for child in enemy_container.get_children():
		var enemy := child as Unit
		if enemy == null or enemy.current_state == State.DEAD:
			continue
		var dist := _distance_to(enemy)
		if dist < closest_dist:
			closest_dist = dist
			closest = enemy

	return closest


## Returns the horizontal distance to another unit.
func _distance_to(other: Unit) -> float:
	return abs(global_position.x - other.global_position.x)


## Returns the Node2D container holding enemy units.
func _get_enemy_container() -> Node2D:
	if unit_data == null:
		return null
	# Human units target GrakkForces, Grakk units target HumanForces.
	var container_name := "GrakkForces" if unit_data.faction == "human" else "HumanForces"
	var battle_root := get_parent().get_parent()
	return battle_root.get_node_or_null(container_name) as Node2D


# --- Signal Callbacks ---

## Health hit 0 — unit is destroyed.
func _on_health_depleted() -> void:
	EventBus.unit_destroyed.emit(self)
	_change_state(State.DEAD)


## Morale hit 0 — either broken (retreat) or inspired (rally).
func _on_morale_broken(result: String) -> void:
	EventBus.unit_morale_break.emit(self, result)
	if result == "broken":
		_change_state(State.RETREAT)
	# If "inspired", the unit stays in its current state with buffed stats.


## Supply ran out — apply a morale penalty.
func _on_supply_empty() -> void:
	stats.lose_morale(15)


# --- State Transitions ---

## Changes to a new state and handles enter/exit logic.
func _change_state(new_state: State) -> void:
	# Exit logic for old state.
	# (none needed yet)

	current_state = new_state

	# Enter logic for new state.
	match new_state:
		State.DEAD:
			_enter_dead()
		State.RETREAT:
			_enter_retreat()


## Enter DEAD: disable the unit and remove it from the battle.
func _enter_dead() -> void:
	set_physics_process(false)
	visible = false
	# Defer removal so other systems can react this frame.
	queue_free()


## Enter RETREAT: unit is fleeing — cannot be given new orders.
func _enter_retreat() -> void:
	# Retreating units move at 80% speed.
	pass
