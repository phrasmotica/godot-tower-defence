class_name Tower extends Node2D

@onready var path: Path = %PathWaypoints

@onready var range_node = $Range
@onready var selection_node = $Selection
@onready var levels_node = $Levels

var is_selected = false

signal on_selected
signal on_deselected

func _ready():
	deselect()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		deselect()

	var near_enemy = get_near_enemy()
	if near_enemy:
		point_towards_enemy(near_enemy, delta)

func select():
	selection_node.show()
	range_node.show()
	is_selected = true

	on_selected.emit()

func deselect():
	selection_node.hide()
	range_node.hide()
	is_selected = false

	on_deselected.emit()

func get_near_enemy():
	var enemies = path.enemies
	if enemies.size() <= 0:
		return null

	if enemies[0] == null or enemies[0].is_queued_for_deletion():
		return null

	var distance_to_enemy = global_position.distance_to(enemies[0].global_position)
	if distance_to_enemy > get_range_px():
		return null

	return enemies[0]

func point_towards_enemy(enemy: Enemy, delta: float):
	var rotate_speed = levels_node.get_current_level().stats.rotate_speed

	# gets the angle we want to face
	var angle_to_enemy = global_position.direction_to(enemy.global_position).angle()

	# slowly changes the rotation to face the angle
	levels_node.rotation = move_toward(levels_node.rotation, angle_to_enemy, delta * rotate_speed)

func get_range_px():
	var level = levels_node.get_current_level()

	# 1 range => 100px
	return level.stats.range * 100

func _on_collision_area_mouse_entered():
	range_node.show()

func _on_collision_area_mouse_exited():
	if not is_selected:
		range_node.hide()

func _on_collision_area_input_event(viewport:Node, event:InputEvent, shape_idx:int):
	if event.is_pressed():
		select()

func _on_barrel_shoot():
	if not get_near_enemy():
		return

	if not levels_node.should_shoot():
		return

	var level = levels_node.get_current_level()
	print("Current level is " + level.name)

	var projectile = level.stats.projectile

	var bullet: Projectile = projectile.instantiate()
	bullet.damage = level.stats.damage
	bullet.direction = Vector2.RIGHT.rotated(levels_node.rotation)

	print("Projectile now has damage " + str(bullet.damage))

	add_child(bullet)
