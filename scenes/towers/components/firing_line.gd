@tool
class_name FiringLine extends Node2D

@onready
var ray_cast_damage: RayCastDamage = $RayCastDamage

@export
var ray_cast: RayCast2D

@export
var enabled := true

@export
var bolt_line: PackedScene

@export_range(1.0, 10.0)
var shooting_range := 3.0:
	set(value):
		shooting_range = value

		_refresh()

func _ready() -> void:
	_refresh()

func _refresh() -> void:
	ray_cast.target_position = Vector2(shooting_range * 100, 0)

func can_see_enemies() -> bool:
	return ray_cast.is_colliding()

func fire(bolt_stats: TowerLevelStats) -> BoltLine:
	ray_cast_damage.process_enemies(ray_cast, bolt_stats)

	var new_line: BoltLine = bolt_line.instantiate()
	new_line.rotate(bolt_stats.get_accuracy_variance() * (randf() - 0.5))

	new_line.ready.connect(
		func() -> void:
			new_line.line.points[1] = ray_cast.target_position
			new_line.fire()
	)

	return new_line
