class_name CannonballStateMoving
extends CannonballState

func _enter_tree() -> void:
	_colliders.enemy_hit.connect(handle_enemy_hit)

func _process(_delta: float) -> void:
	_cannonball.translate(_movement.translate())

	if _movement.is_finished():
		_cannonball.queue_free()

func handle_collision(enemy: Enemy) -> void:
	handle_enemy_hit(enemy)

func handle_enemy_hit(enemy: Enemy) -> void:
	_colliders.disable()

	var state_data := CannonballStateData.build().with_enemy(enemy)
	transition_state(Cannonball.State.EXPLODING, state_data)
