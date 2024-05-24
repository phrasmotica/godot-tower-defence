class_name Enemy extends PathFollow2D

## Movement speed in pixels per second.
@export_range(100, 300)
var movement_speed: int = 150

@onready var health_bar: HealthBar = $HealthBar
@onready var stats: EnemyStats = $Stats
@onready var animation_player: AnimationPlayer = $AnimationPlayer

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
	if progress_ratio < 1.0:
		progress += movement_speed * delta
	else:
		reached_end.emit(self)

func get_neighbours(max_distance_px: float) -> Array[Enemy]:
	var enemies = get_tree().get_nodes_in_group("enemies")
	enemies.erase(self)

	var neighbours: Array[Enemy] = (
		enemies
			.filter(func(e): return global_position.distance_to(e.global_position) <= max_distance_px)
			# TODO: this casting isn't returning the node as an Enemy object
			.map(func(e): return e as Enemy)
	)

	return neighbours

func get_neighbour(max_distance_px: float) -> Enemy:
	var nearby_enemies := get_neighbours(max_distance_px)
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
	handle_strike(body)

func handle_aoe(body: Projectile):
	handle_strike(body)

func handle_strike(body: Projectile):
	hit.emit(body)

	var new_health = stats.take_damage(body.damage)
	health_bar.draw_health(new_health)

	animation_player.stop()
	animation_player.play("peek_health")

	if new_health <= 0:
		die.emit(self)

	body.handle_collision(self)
