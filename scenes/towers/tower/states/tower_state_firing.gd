class_name TowerStateFiring
extends TowerState

func _enter_tree() -> void:
	print("Tower is now firing")

func _process(delta: float) -> void:
	_tower.scan(delta)
