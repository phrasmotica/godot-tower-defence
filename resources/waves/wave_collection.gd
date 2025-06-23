class_name WaveCollection extends Resource

@export
var waves: Array[Wave] = []

func get_wave(index: int) -> Wave:
	if index < 0 or index >= waves.size():
		return null

	return waves[index]
