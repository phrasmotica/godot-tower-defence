## Projectile that damages all enemies in an area
## centred on the enemy that is struck.
class_name Cannonball extends Projectile

@export_range(1, 6)
var area_radius := 1

@onready
var explosion_scene := preload("res://scenes/projectiles/cannonball/explosion.tscn")

@onready
var sprite: AnimatedSprite2D = %Sprite

@onready
var collider: CollisionShape2D = %Collider

var _has_hit := false

func _process(_delta: float) -> void:
	if not _has_hit:
		translate(direction * speed)

		check_free()

func handle_collision(enemy: Enemy) -> void:
	_has_hit = true

	var explosion: Explosion = explosion_scene.instantiate()
	explosion.time_period = 0.1

	# the unscaled explosion shader has a radius of 200px. So halving its scale
	# means it has the correct radius
	explosion.scale = 0.5 * area_radius * Vector2.ONE

	add_child(explosion)

	var neighbours = EnemyManager.get_neighbours(enemy, 100 * area_radius)

	print("Affecting " + str(neighbours.size()) + " neighbour(s) in radius " + str(area_radius))

	for e in neighbours:
		(e as Enemy).handle_aoe(self)

	sprite.hide()
	collider.set_deferred("disabled", true)
