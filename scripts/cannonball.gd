## Projectile that damages all enemies in an area
## centred on the enemy that is struck.
class_name Cannonball extends Projectile

@export_range(3, 6)
var area_radius := 3

func handle_collision(enemy: Enemy):
	var neighbours := enemy.get_neighbours(100 * area_radius)

	print("Affecting " + str(neighbours.size()) + " neighbour(s) in radius " + str(area_radius))

	for e in neighbours:
		e.handle_aoe(self)

	print("Freeing after collision with " + enemy.name)
	queue_free()
