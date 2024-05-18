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
func ricochet(_enemy: Enemy):
	speed = int(speed * 0.5)

	# TODO: implement change of direction

	pass
