class_name Enemy extends PathFollow2D

## Movement speed in pixels per second.
@export_range(100, 300)
var movement_speed: int = 150

@onready var health_bar: HealthBar = $HealthBar
@onready var stats: EnemyStats = $Stats
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_speed := 0.0
var is_slowed := false

signal hit(body:Node2D)
signal die(enemy: Enemy)
signal reached_end(enemy: Enemy)

func _ready():
	health_bar.set_max_health(stats.starting_health)
	health_bar.hide()

func _process(delta):
	move(delta)

func move(delta):
	accelerate(delta)

	if progress_ratio < 1.0:
		progress += current_speed * delta
	else:
		reached_end.emit(self)

func accelerate(delta):
	if current_speed < movement_speed:
		current_speed = move_toward(current_speed, movement_speed, delta * movement_speed)

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
	movement_speed /= 2

	var animation_speed = float(1 / duration)
	animation_player.play("slow", -1, animation_speed)

func end_slow():
	movement_speed *= 2
	is_slowed = false

func _on_collision_area_body_entered(body: Projectile):
	handle_strike(body, true)

func handle_aoe(body: Projectile):
	# gentler knockback for an indirect hit. Also don't re-trigger the
	# projectile's collision handler
	handle_strike(body, false, 0.5)

func handle_bolt(bolt_stats: TowerLevelStats):
	# TODO: emit some variant of the hit signal?

	handle_damage(bolt_stats.damage)
	handle_knockback(bolt_stats.projectile_knockback)

func handle_strike(body: Projectile, propagate: bool, knockback_mult := 1.0):
	hit.emit(body)

	handle_damage(body.damage)
	handle_knockback(body.knockback, knockback_mult)

	if propagate:
		body.handle_collision(self)

func handle_damage(amount: int):
	var new_health = stats.take_damage(amount)
	health_bar.draw_health(new_health)

	if new_health <= 0:
		die.emit(self)

	animation_player.stop()
	animation_player.play("peek_health")

func handle_knockback(amount: float, mult := 1.0):
	if mult > 0:
		var knockback_factor = amount * mult
		print("Knocking enemy back by factor of " + str(knockback_factor))
		current_speed = current_speed * (1 - (knockback_factor / 100.0))
