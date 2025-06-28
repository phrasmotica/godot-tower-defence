class_name CannonballStateMoving
extends CannonballState

func _enter_tree() -> void:
	_cannonball.start_position = _cannonball.global_position

func _process(_delta: float) -> void:
	_cannonball.translate(_cannonball.direction * _cannonball.speed)

	_cannonball.check_free()

func handle_collision(enemy: Enemy) -> void:
	_cannonball.collider.set_deferred("disabled", true)

	var state_data := CannonballStateData.build().with_enemy(enemy)
	transition_state(Cannonball.State.EXPLODING, state_data)
