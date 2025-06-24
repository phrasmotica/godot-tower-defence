class_name Enemy extends PathFollow2D

enum State { MOVING, PARALYSED, POISONED, SLOWED, DYING }

## Movement speed in pixels per second.
@export_range(100.0, 300.0)
var movement_speed := 150.0

## Amount of money rewarded for killing this enemy.
@export_range(1, 5)
var bounty := 1

@onready
var appearance: EnemyAppearance = %Appearance

@onready
var stats: EnemyStats = %Stats

# TODO: create an EnemyMovement abstraction script for this
var current_speed := 0.0

signal bolted
signal hit(body:Node2D)

var _info: EnemyInfo = null

var _state_factory := EnemyStateFactory.new()
var _current_state: EnemyState = null

func _ready() -> void:
	_info = EnemyInfo.new("ENEMY_NAME", bounty)

	appearance.set_max_health(stats.starting_health)
	appearance.hide_health()

	switch_state(State.MOVING)

func switch_state(state: State, state_data := EnemyStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		appearance,
		null, #colliders,
		_info,
		null) #interaction)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "EnemyStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func set_max_health(amount: float) -> void:
	stats.starting_health = amount
	stats.current_health = amount

	appearance.set_max_health(amount)

func set_max_speed(amount: float):
	movement_speed = amount

func set_bounty(amount: int):
	bounty = amount

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

func can_be_slowed() -> bool:
	return _current_state != null and _current_state.can_be_slowed()

func slow(effect: SlowEffect) -> void:
	switch_state(State.SLOWED, EnemyStateData.build().with_effect(effect))

func can_be_paralysed() -> bool:
	return _current_state != null and _current_state.can_be_paralysed()

func paralyse(effect: ParalyseEffect) -> void:
	switch_state(State.PARALYSED, EnemyStateData.build().with_effect(effect))

func can_be_poisoned() -> bool:
	return _current_state != null and _current_state.can_be_poisoned()

func poison(effect: PoisonEffect) -> void:
	switch_state(State.POISONED, EnemyStateData.build().with_effect(effect))

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
	appearance.set_current_health(new_health)

	if new_health > 0:
		appearance.animate_peek_health()
	else:
		switch_state(State.DYING)

func handle_knockback(amount: float, mult := 1.0):
	if mult > 0:
		var knockback_factor = amount * mult
		print("Knocking enemy back by factor of " + str(knockback_factor))
		current_speed = current_speed * (1 - (knockback_factor / 100.0))
