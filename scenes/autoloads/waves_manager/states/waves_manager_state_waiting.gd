class_name WavesManagerStateWaiting
extends WavesManagerState

func _enter_tree() -> void:
	print("WavesManager is now waiting")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var next_wave := _waves_manager.next()

		if next_wave != null:
			send(next_wave)

func send(wave: Wave) -> void:
	print("Started sending wave %d" % wave.number)

	if wave.resource_path.length() > 0:
		print("Using %s resource" % wave.resource_path)

	WaveEvents.emit_wave_sent(wave)

	var spawned_count := 0

	for i in range(wave.spawn_count):
		var enemy := EnemyManager.spawn_enemy(wave.enemy)

		for e in wave.enhancements:
			e.act(enemy)

		spawned_count += 1

		if spawned_count < wave.spawn_count:
			await get_tree().create_timer(1.0 / wave.spawn_frequency).timeout

	print("Finished sending wave %d" % wave.number)
