class_name FiringLine extends Node2D

@onready var ray_cast: RayCast2D = $RayCast
@onready var line: Line2D = $Line
@onready var ray_cast_damage: RayCastDamage = $RayCastDamage
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var enabled := true

func _ready():
	line.hide()

func set_target(projectile_range: int):
	ray_cast.target_position = Vector2(projectile_range * 100, 0)

func can_see_enemies():
	return ray_cast.is_colliding()

func fire(bolt_stats: TowerLevelStats):
	animation_player.play("fire")

	ray_cast_damage.process_enemies(ray_cast, bolt_stats)
