class_name WavesManagerStateWaiting
extends WavesManagerState

func _enter_tree() -> void:
	print("WavesManager is now waiting")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var next_wave := _waves_manager.next()

		var state_data := WavesManagerStateData \
			.build() \
			.with_wave(next_wave)

		transition_state(WavesManager.State.SENDING, state_data)
