extends PanelContainer

@onready
var next_button: IconButton = %NextButton

@onready
var speed_button: IconButton = %SpeedButton

@onready
var wave_tooltip: Tooltip = %WaveTooltip

func _ready() -> void:
	next_button.pressed.connect(_on_next_button_pressed)
	speed_button.toggled.connect(_on_speed_button_toggled)

	WaveEvents.wave_sent.connect(_on_wave_sent)

func _on_next_button_pressed() -> void:
	WaveEvents.emit_wave_requested()

func _on_speed_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		SpeedEvents.emit_speed_fast_requested()
	else:
		SpeedEvents.emit_speed_normal_requested()

func _on_wave_sent(wave: Wave) -> void:
	wave_tooltip.text = wave.description
