class_name TowerStateWarmup
extends TowerState

func _enter_tree() -> void:
	print("Tower is now warming up")

	_tower.hide_visualiser()

	_progress_bars.do_warmup()
