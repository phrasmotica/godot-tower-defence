class_name Enemy extends PathFollow2D

## Movement speed in pixels per second.
@export_range(100, 300)
var movement_speed: int = 150

@onready var health_bar: HealthBar = $HealthBar
@onready var stats: EnemyStats = $Stats
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal hit(body:Node2D)
signal die(enemy: Enemy)
signal reached_end(enemy: Enemy)

func _ready():
	health_bar.set_max_health(stats.starting_health)
	health_bar.hide()

func _process(delta):
	move(delta)

func move(delta):
	if progress_ratio < 1.0:
		progress += movement_speed * delta
	else:
		reached_end.emit(self)

func _on_collision_area_body_entered(body: Projectile):
	hit.emit(body)

	var new_health = stats.take_damage(body.damage)
	health_bar.draw_health(new_health)

	animation_player.stop()
	animation_player.play("peek_health")

	if new_health <= 0:
		die.emit(self)

	# TODO: add some visual/audio flair to enemy-projectile collision
	body.queue_free()
