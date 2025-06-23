class_name WavesManagerStateData

var _wave: Wave

static func build() -> WavesManagerStateData:
	return WavesManagerStateData.new()

func with_wave(wave: Wave) -> WavesManagerStateData:
	_wave = wave
	return self

func get_wave() -> Wave:
	return _wave
