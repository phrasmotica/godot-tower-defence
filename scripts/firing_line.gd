@tool
class_name FiringLine extends Node2D

@onready var ray_cast_damage: RayCastDamage = $RayCastDamage

@export var ray_cast: RayCast2D
@export var enabled := true
@export var bolt_line: PackedScene

@export_range(1.0, 10.0)
var shooting_range := 3.0:
	set(value):
		shooting_range = value

		set_target(value)

signal created_line(bolt_line: BoltLine)

func _ready():
	set_target(shooting_range)

func set_target(projectile_range: float):
	ray_cast.target_position = Vector2(projectile_range * 100, 0)

func can_see_enemies():
	return ray_cast.is_colliding()

func fire(bolt_stats: TowerLevelStats):
	ray_cast_damage.process_enemies(ray_cast, bolt_stats)

	var new_line: BoltLine = bolt_line.instantiate()
	new_line.line.points[1] = ray_cast.target_position

	created_line.emit(new_line)

func _on_levels_adjust_range(projectile_range: float):
	shooting_range = projectile_range
