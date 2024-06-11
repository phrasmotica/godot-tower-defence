class_name Effect extends Node

var effect_duration: float

var attached_enemies: Array[Enemy]

func _process(delta):
	act_process(delta)

func start_timer():
	print("Effect duration " + str(effect_duration))

	var timer = get_tree().create_timer(effect_duration)

	timer.timeout.connect(act_end)
	timer.timeout.connect(queue_free)

func act_start():
	# implemented in child classes
	pass

func act_process(_delta):
	# implemented in child classes
	pass

func act_end():
	# implemented in child classes
	pass

func can_act(_enemy: Enemy):
	# implemented in child classes
	return false
