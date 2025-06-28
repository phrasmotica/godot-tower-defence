## Projectile that damages all enemies in an area
## centred on the enemy that is struck.
class_name Cannonball extends Projectile

@export_range(3, 6)
var area_radius := 3

@onready
var explosion_scene := preload("res://scenes/projectiles/explosion.tscn")

@onready
var sprite: AnimatedSprite2D = %Sprite

@onready
var collider: CollisionShape2D = %Collider

var _has_hit := false

func _process(_delta: float) -> void:
	if not _has_hit:
		translate(direction * speed)

func handle_collision(enemy: Enemy) -> void:
	_has_hit = true

	var explosion: Explosion = explosion_scene.instantiate()
	explosion.time_period = 0.1

	# nominal scale - 0.75 is suitable for a radius of 3
	# TODO: the unscaled explosion shader has a radius of 200px. Use this to
	# scale it properly...
	explosion.scale = 0.25 * area_radius * Vector2.ONE

	add_child(explosion)

	var neighbours = EnemyManager.get_neighbours(enemy, 100 * area_radius)

	print("Affecting " + str(neighbours.size()) + " neighbour(s) in radius " + str(area_radius))

	for e in neighbours:
		(e as Enemy).handle_aoe(self)

	sprite.hide()
	collider.set_deferred("disabled", true)
