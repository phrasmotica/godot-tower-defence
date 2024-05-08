class_name Enemy extends PathFollow2D

@export_range(0.1, 0.2)
var movement_speed: float

@onready var health_bar: HealthBar = $HealthBar
@onready var stats: EnemyStats = $Stats

signal hit(body:Node2D)
signal reached_end(enemy: Enemy)

func _ready():
	health_bar.set_max_health(stats.starting_health)

func _process(delta):
	move(delta)

func move(delta):
	if progress_ratio < 1.0:
		progress_ratio += movement_speed * delta
	else:
		reached_end.emit(self)
		remove()

func _on_collision_area_body_entered(body:Node2D):
	hit.emit(body)

	var new_health = stats.take_damage(1)
	health_bar.draw_health(new_health)

	if new_health <= 0:
		die()

	body.queue_free()

func remove():
	queue_free()

func die():
	print("I am dead!")
	queue_free()
