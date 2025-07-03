class_name TowerStateDisabled
extends TowerState

func _enter_tree() -> void:
	Logger.info("%s is now disabled" % _info.get_name())
