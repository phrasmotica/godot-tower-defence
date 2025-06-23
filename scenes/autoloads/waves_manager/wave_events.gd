extends Node

signal waves_began
signal wave_sent(wave: Wave)

func emit_waves_began() -> void:
	waves_began.emit()

func emit_wave_sent(wave: Wave) -> void:
	wave_sent.emit(wave)
