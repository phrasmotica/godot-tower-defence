class_name EnemySorter

# nearest enemies first
func near(enemies: Array[Enemy], pos: Vector2):
    enemies.sort_custom(
        func(e, f):
            return sort_near(e, f, pos)
    )

func sort_near(e: Enemy, f: Enemy, pos: Vector2):
    return e.get_distance_to(pos) < f.get_distance_to(pos)
