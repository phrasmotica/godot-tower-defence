class_name Effect extends Node

var effect_duration: float

var enemy: Enemy

func start_timer():
	Logger.info("Effect duration %.1f" % effect_duration)

	var timer = get_tree().create_timer(effect_duration)

	timer.timeout.connect(queue_free)

func can_act() -> bool:
	# implemented in child classes
	return false
