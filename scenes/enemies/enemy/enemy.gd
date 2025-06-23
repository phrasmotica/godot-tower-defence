class_name Enemy extends PathFollow2D

enum State { MOVING, PARALYSED, POISONED, SLOWED, DYING }

## Movement speed in pixels per second.
@export_range(100.0, 300.0)
var movement_speed := 150.0

## Amount of money rewarded for killing this enemy.
@export_range(1, 5)
var bounty := 1

@onready var health_bar: HealthBar = $HealthBar
@onready var stats: EnemyStats = $Stats
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_speed := 0.0
var is_slowed := false
var is_paralysed := false
var is_poisoned := false

signal bolted
signal hit(body:Node2D)
signal die(enemy: Enemy)
signal reached_end(enemy: Enemy)

var _info: EnemyInfo = null

var _state_factory := EnemyStateFactory.new()
var _current_state: EnemyState = null

func _ready() -> void:
	_info = EnemyInfo.new("ENEMY_NAME", bounty)

	health_bar.set_max_health(stats.starting_health)
	health_bar.hide()

	switch_state(State.MOVING)

func switch_state(state: State, state_data := EnemyStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		null, #appearance,
		null, #colliders,
		_info,
		null) #interaction)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "EnemyStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func _process(delta):
	move(delta)

func set_max_health(amount: float):
	stats.starting_health = amount
	stats.current_health = amount

	health_bar.set_max_health(amount)

func set_max_speed(amount: float):
	movement_speed = amount

func set_bounty(amount: int):
	bounty = amount

func move(delta):
	if can_move():
		accelerate(delta)

		if progress_ratio < 1.0:
			progress += current_speed * delta
		else:
			reached_end.emit(self)

func accelerate(delta):
	if can_accelerate():
		current_speed = move_toward(current_speed, movement_speed, delta * movement_speed)

func can_move():
	return not is_paralysed

func can_accelerate():
	return not (is_slowed or is_paralysed) and current_speed < movement_speed

func get_neighbours(max_distance_px: float):
	var enemies = get_tree().get_nodes_in_group("enemies")
	enemies.erase(self)

	if enemies.size() <= 0:
		return []

	var neighbours = enemies.filter(func(e): return global_position.distance_to(e.global_position) <= max_distance_px)

	return neighbours

func get_neighbour(max_distance_px: float) -> Enemy:
	var nearby_enemies = get_neighbours(max_distance_px)
	if nearby_enemies.size() <= 0:
		return null

	# nearest enemies first
	nearby_enemies.sort_custom(
		func(e, f):
			return e.get_distance_to(global_position) < f.get_distance_to(global_position)
	)

	return nearby_enemies[0]

func get_distance_to(pos: Vector2):
	return pos.distance_to(global_position)

func slow(duration: float):
	is_slowed = true
	current_speed /= 2

	var animation_speed = float(1 / duration)
	animation_player.play("slow", -1, animation_speed)

func end_slow():
	is_slowed = false

func paralyse(duration: float):
	is_paralysed = true
	current_speed = 0

	var animation_speed = float(1 / duration)
	animation_player.play("paralyse", -1, animation_speed)

func end_paralyse():
	is_paralysed = false

func poison(duration: float):
	is_poisoned = true

	var animation_speed = float(1 / duration)
	animation_player.play("poison", -1, animation_speed)

func end_poison():
	is_poisoned = false

func _on_collision_area_body_entered(body: Projectile):
	handle_strike(body, true)

func handle_aoe(body: Projectile):
	# gentler knockback for an indirect hit. Also don't re-trigger the
	# projectile's collision handler
	handle_strike(body, false, 0.5)

func handle_bolt(bolt_stats: TowerLevelStats):
	bolted.emit()

	handle_damage(bolt_stats.damage)
	handle_knockback(bolt_stats.projectile_knockback)

func handle_strike(body: Projectile, propagate: bool, knockback_mult := 1.0):
	hit.emit(body)

	handle_damage(body.damage)
	handle_knockback(body.knockback, knockback_mult)

	if propagate:
		body.handle_collision(self)

func handle_damage(amount: float):
	var new_health = stats.take_damage(amount)
	health_bar.draw_health(new_health)

	if new_health <= 0:
		animation_player.stop()
		animation_player.play("die")

		die.emit(self)

		return

	animation_player.stop()
	animation_player.play("peek_health")

func handle_knockback(amount: float, mult := 1.0):
	if mult > 0:
		var knockback_factor = amount * mult
		print("Knocking enemy back by factor of " + str(knockback_factor))
		current_speed = current_speed * (1 - (knockback_factor / 100.0))
