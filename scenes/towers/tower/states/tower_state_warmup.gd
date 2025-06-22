class_name TowerStateWarmup
extends TowerState

func _enter_tree() -> void:
	print("%s is now warming up" % _tower.tower_name)

	_appearance.hide_visualiser()

	_interaction.mouse_entered.connect(_on_mouse_entered)
	_interaction.mouse_exited.connect(_on_mouse_exited)

	_interaction.enable_mouse()

	_weaponry.start_warmup()

	_appearance.do_warmup(_on_warmup_finished)

func _on_mouse_entered() -> void:
	_appearance.show_visualiser()

func _on_mouse_exited() -> void:
	_appearance.hide_visualiser()

func _on_warmup_finished() -> void:
	print("%s has finished warming up" % _tower.tower_name)

	var base_level := _weaponry.install_base()

	TowerEvents.emit_tower_warmup_finished(_tower, base_level)

	transition_state(Tower.State.FIRING)
