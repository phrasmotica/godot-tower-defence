class_name WaveCollection extends Resource

@export var waves: Array[Wave] = []

func count() -> int:
    return waves.size()

func get_wave(number: int) -> Wave:
    return waves[number - 1]
