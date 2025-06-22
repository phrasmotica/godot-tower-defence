class_name TowerStateDisabled
extends TowerState

func _enter_tree() -> void:
	print("%s is now disabled" % _tower.tower_name)
