class_name CannonballStateMoving
extends CannonballState

func _process(_delta: float) -> void:
	_cannonball.translate(_movement.translate())

	if _movement.is_finished():
		_cannonball.queue_free()

func handle_collision(enemy: Enemy) -> void:
	_cannonball.collider.set_deferred("disabled", true)

	var state_data := CannonballStateData.build().with_enemy(enemy)
	transition_state(Cannonball.State.EXPLODING, state_data)
