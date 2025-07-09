extends PanelContainer

@onready
var next_button: IconButton = %NextButton

func _ready() -> void:
	next_button.pressed.connect(_on_next_button_pressed)

func _on_next_button_pressed() -> void:
	WaveEvents.emit_wave_requested()
