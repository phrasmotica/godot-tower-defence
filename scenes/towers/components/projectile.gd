class_name Projectile extends Node2D

var damage := 1
var speed := 10
var knockback := 0.0
var penetration_count := 0

var direction: Vector2
var effective_range: float

var _movement: ProjectileMovement = null

func _ready() -> void:
	_movement = ProjectileMovement.new(direction, effective_range, speed)

func _process(_delta: float) -> void:
	translate(_movement.translate())

	if _movement.is_finished():
		queue_free()

func handle_collision(enemy: Enemy) -> void:
	if penetration_count > 0:
		penetration_count -= 1
		print("Collided with " + enemy.name + ", " + str(penetration_count) + " penetration(s) remaining")
		return

	print("Freeing after collision with " + enemy.name)
	queue_free()
