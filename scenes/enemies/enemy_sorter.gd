class_name EnemySorter

# nearest enemies first
func near(enemies: Array[Enemy], pos: Vector2):
	enemies.sort_custom(
		func(e, f):
			return sort_near(e, f, pos)
	)

# furthest enemies first
func far(enemies: Array[Enemy], pos: Vector2):
	enemies.sort_custom(
		func(e, f):
			return sort_far(e, f, pos)
	)

# strongest enemies first
func strong(enemies: Array[Enemy]):
	enemies.sort_custom(
		func(e, f):
			return sort_strong(e, f)
	)

func sort_near(e: Enemy, f: Enemy, pos: Vector2):
	return e.global_position.distance_to(pos) < f.global_position.distance_to(pos)

func sort_far(e: Enemy, f: Enemy, pos: Vector2):
	return not sort_near(e, f, pos)

func sort_strong(e: Enemy, f: Enemy):
	return e.stats.get_current_health() > f.stats.get_current_health()
