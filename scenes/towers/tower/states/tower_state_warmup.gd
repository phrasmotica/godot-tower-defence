class_name TowerStateWarmup
extends TowerState

func _enter_tree() -> void:
	Logger.info("%s is now warming up" % _info.get_name())

	_interaction.hide_visualiser()

	_interaction.mouse_entered.connect(_on_mouse_entered)
	_interaction.mouse_exited.connect(_on_mouse_exited)

	_interaction.enable_mouse()

	_appearance.do_warmup()
	_interaction.do_warmup(_on_warmup_finished)

func _on_mouse_entered() -> void:
	_interaction.show_visualiser()

func _on_mouse_exited() -> void:
	_interaction.hide_visualiser()

func _on_warmup_finished() -> void:
	Logger.info("%s has finished warming up" % _info.get_name())

	var base_level := _weaponry.install_base()

	_interaction.set_level(base_level)

	TowerEvents.emit_tower_warmup_finished(_tower, base_level)

	transition_state(Tower.State.FIRING)
