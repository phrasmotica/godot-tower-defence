## Projectile that damages all enemies in an area
## centred on the enemy that is struck.
class_name Cannonball extends Projectile

@export_range(3, 6)
var area_radius := 3

@export
var explosion: Explosion = null

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var collider: CollisionShape2D = $Collider

func handle_collision(enemy: Enemy) -> void:
	if explosion:
		explosion.show()
		explosion.explode()

	var neighbours = EnemyManager.get_neighbours(enemy, 100 * area_radius)

	print("Affecting " + str(neighbours.size()) + " neighbour(s) in radius " + str(area_radius))

	for e in neighbours:
		(e as Enemy).handle_aoe(self)

	sprite.hide()
	collider.set_deferred("disabled", true)
