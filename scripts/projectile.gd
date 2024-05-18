class_name Projectile extends Node2D

var damage := 1
var speed := 10

var direction: Vector2
var start_position: Vector2
var effective_range: int

func _ready():
    start_position = global_position

func _process(_delta):
    translate(direction * speed)

    check_free()

func check_free():
    if global_position.distance_to(start_position) >= effective_range * 100:
        queue_free()

func handle_collision(enemy: Enemy):
    print("Freeing after collision with " + enemy.name)
    queue_free()
