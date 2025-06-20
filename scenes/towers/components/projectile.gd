class_name Projectile extends Node2D

var damage := 1
var speed := 10
var knockback := 0.0
var penetration_count := 0

var direction: Vector2
var start_position: Vector2
var effective_range: float

func _ready():
    start_position = global_position

func _process(_delta):
    translate(direction * speed)

    check_free()

func check_free():
    if global_position.distance_to(start_position) >= effective_range * 100:
        queue_free()

func handle_collision(enemy: Enemy):
    if penetration_count > 0:
        penetration_count -= 1
        print("Collided with " + enemy.name + ", " + str(penetration_count) + " penetration(s) remaining")
        return

    print("Freeing after collision with " + enemy.name)
    queue_free()
