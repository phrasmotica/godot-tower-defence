class_name FiringLine extends Node2D

@onready var ray_cast: RayCast2D = $RayCast
@onready var line: Line2D = $Line
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var enabled := true

func _ready():
	line.hide()

func set_target(projectile_range: int):
	ray_cast.target_position = Vector2(projectile_range * 100, 0)

func can_see_enemies():
	return ray_cast.is_colliding()

func fire():
	animation_player.play("fire")

	var enemy_collider = ray_cast.get_collider()
	var enemy := (enemy_collider as CollisionObject2D).get_parent() as Enemy

	# TODO: take the correct amount of damage
	enemy.handle_bolt(5)
