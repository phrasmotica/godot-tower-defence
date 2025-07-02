class_name TowerStateUpgrading
extends TowerState

func _enter_tree() -> void:
	print("%s has started upgrading" % _info.get_name())

	_interaction.mouse_entered.connect(_on_mouse_entered)
	_interaction.mouse_exited.connect(_on_mouse_exited)

	_interaction.enable_mouse()

	var upgrade_index := _state_data.get_upgrade_index()

	var next_level := _weaponry.start_upgrade(upgrade_index)
	if next_level:
		_weaponry.pause()

		_appearance.do_upgrade()
		_interaction.do_upgrade(_on_upgrade_finished)

func _on_mouse_entered() -> void:
	_interaction.show_visualiser()

func _on_mouse_exited() -> void:
	if not _interaction.is_selected():
		_interaction.hide_visualiser()

func _on_upgrade_finished() -> void:
	print("%s has finished upgrading" % _info.get_name())

	var next_level := _weaponry.install_upgrade()

	_appearance.set_level(next_level)

	_interaction.range_radius = next_level.get_range(true)

	var upgrade_index := _state_data.get_upgrade_index()

	TowerEvents.emit_tower_upgrade_finished(upgrade_index, _tower, next_level)

	transition_state(Tower.State.FIRING)

func is_upgrading() -> bool:
	return true

func can_be_selected() -> bool:
	return true
