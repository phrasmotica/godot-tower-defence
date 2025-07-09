extends PanelContainer

@onready
var next_button: IconButton = %NextButton

@onready
var speed_button: IconButton = %SpeedButton

func _ready() -> void:
	next_button.pressed.connect(_on_next_button_pressed)
	speed_button.toggled.connect(_on_speed_button_toggled)

func _on_next_button_pressed() -> void:
	WaveEvents.emit_wave_requested()

func _on_speed_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		SpeedEvents.emit_speed_fast_requested()
	else:
		SpeedEvents.emit_speed_normal_requested()
