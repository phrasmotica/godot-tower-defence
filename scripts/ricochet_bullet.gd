## Bullet that bounces off the the hit enemy
## and ricochets into its nearest neighbour.
class_name RicochetBullet extends Projectile

@export_range(1, 2)
var max_ricochets := 1

@onready
var ricochet_count := max_ricochets

func handle_collision(enemy: Enemy):
	if ricochet_count > 0:
		ricochet_count -= 1
		print("Collided with " + enemy.name + ", " + str(ricochet_count) + " ricochet(s) remaining")
		ricochet(enemy)
		return

	print("Freeing after collision with " + enemy.name + ", no ricochets remaining")
	queue_free()

## Rebound into the given enemy's nearest neighbour.
func ricochet(enemy: Enemy):
	speed = int(speed * 0.5)

	var nearest_enemy = enemy.get_neighbour(effective_range * 100)
	if nearest_enemy:
		print("Ricocheting towards " + nearest_enemy.name)

		var new_rotation := global_position.direction_to(nearest_enemy.global_position)
		rotation = new_rotation.angle()
		direction = new_rotation
	else:
		print("No nearby enemy to ricochet towards!")
