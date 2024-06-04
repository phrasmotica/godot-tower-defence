@tool
class_name FiringLine extends Node2D

@onready var ray_cast_damage: RayCastDamage = $RayCastDamage

@export var ray_cast: RayCast2D
@export var example_bolt_line: Line2D

@export var enabled := true
@export var bolt_line: PackedScene

@export_range(1, 10)
var shooting_range := 3:
	set(value):
		shooting_range = value
		ray_cast.target_position.x = 100 * value

		if Engine.is_editor_hint():
			example_bolt_line.points[1].x = 100 * value

signal created_line(bolt_line: Line2D)

func _ready():
	if not Engine.is_editor_hint():
		example_bolt_line.hide()

func set_target(projectile_range: int):
	ray_cast.target_position = Vector2(projectile_range * 100, 0)

func can_see_enemies():
	return ray_cast.is_colliding()

func fire(bolt_stats: TowerLevelStats):
	ray_cast_damage.process_enemies(ray_cast, bolt_stats)

	var line: Line2D = bolt_line.instantiate()
	line.points[1] = ray_cast.target_position

	created_line.emit(line)
