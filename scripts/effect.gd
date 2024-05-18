class_name Effect extends Node

var effect_duration: float

var attached_enemy: Enemy

func set_timer(duration: float):
	print("Effect duration " + str(duration))

	effect_duration = duration

	var timer = get_tree().create_timer(duration)

	timer.timeout.connect(act_end)
	timer.timeout.connect(queue_free)

func act_start():
	# implemented in child classes
	pass

func act_end():
	# implemented in child classes
	pass

func can_act(_enemy: Enemy):
	# implemented in child classes
	return false
