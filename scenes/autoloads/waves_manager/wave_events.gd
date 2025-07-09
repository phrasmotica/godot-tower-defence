extends Node

signal waves_began
signal wave_requested
signal wave_sent(wave: Wave)

func emit_waves_began() -> void:
	waves_began.emit()

func emit_wave_requested() -> void:
	wave_requested.emit()

func emit_wave_sent(wave: Wave) -> void:
	wave_sent.emit(wave)
