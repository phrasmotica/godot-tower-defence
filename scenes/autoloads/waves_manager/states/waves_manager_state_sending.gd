class_name WavesManagerStateSending
extends WavesManagerState

func _enter_tree() -> void:
	var wave := _state_data.get_wave()

	send(wave)

func send(wave: Wave) -> void:
	var spawned_count := 0

	for i in range(wave.spawn_count):
		var enemy := EnemyManager.spawn_enemy(wave.enemy)

		for e in wave.enhancements:
			e.act(enemy)

		spawned_count += 1

		if spawned_count < wave.spawn_count:
			await get_tree().create_timer(1.0 / wave.spawn_frequency).timeout

	transition_state(WavesManager.State.WAITING)
