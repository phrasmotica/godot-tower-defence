class_name FiringLine extends Node2D

@onready var ray_cast: RayCast2D = $RayCast
@onready var example_bolt_line: Line2D = $ExampleBoltLine
@onready var ray_cast_damage: RayCastDamage = $RayCastDamage

@export var enabled := true
@export var bolt_line: PackedScene

signal created_line(bolt_line: Line2D)

func _ready():
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
