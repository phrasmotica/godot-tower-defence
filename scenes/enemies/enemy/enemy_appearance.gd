class_name EnemyAppearance
extends Node2D

@export
var health_bar: HealthBar

@export
var animation_player: AnimationPlayer

func set_max_health(amount: float) -> void:
	health_bar.set_max_health(amount)

func set_current_health(amount: float) -> void:
	health_bar.draw_health(amount)

func show_health() -> void:
	health_bar.show()

func hide_health() -> void:
	health_bar.hide()

func animate_peek_health() -> void:
	animation_player.stop()
	animation_player.play("peek_health")

func animate_paralyse(speed: float) -> void:
	animation_player.play("paralyse", -1, speed)

func animate_poison(speed: float) -> void:
	animation_player.play("poison", -1, speed)

func animate_slow(speed: float) -> void:
	animation_player.play("slow", -1, speed)

func animate_die() -> void:
	# this animation removes the enemy when it ends
	animation_player.stop()
	animation_player.play("die")
