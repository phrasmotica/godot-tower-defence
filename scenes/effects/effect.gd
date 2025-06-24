class_name Effect extends Node

var effect_duration: float

# TODO: don't attach enemies to this effect. Instead attach one copy of this
# effect to each enemy node that it affects...
var attached_enemies: Array[Enemy]

func _ready() -> void:
	EnemyEvents.enemy_died.connect(_on_enemy_died)

func _process(delta):
	act_process(delta)

func start_timer():
	print("Effect duration " + str(effect_duration))

	var timer = get_tree().create_timer(effect_duration)

	timer.timeout.connect(act_end)
	timer.timeout.connect(queue_free)

func _on_enemy_died(enemy: Enemy) -> void:
	attached_enemies.erase(enemy)

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
