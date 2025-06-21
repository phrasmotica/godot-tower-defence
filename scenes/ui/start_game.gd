class_name StartGame extends Control

func _ready():
	show()

func _on_play_button_0_pressed():
	print("Playing path 0")
	hide()

	GameEvents.emit_game_started(0)

func _on_play_button_1_pressed():
	print("Playing path 1")
	hide()

	GameEvents.emit_game_started(1)

func _on_play_button_0_mouse_entered():
	GameEvents.emit_path_previewed(0)

func _on_play_button_1_mouse_entered():
	GameEvents.emit_path_previewed(1)

func _on_play_button_0_focus_entered():
	GameEvents.emit_path_previewed(0)

func _on_play_button_1_focus_entered():
	GameEvents.emit_path_previewed(1)
