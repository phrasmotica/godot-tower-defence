class_name Tower extends Node2D

enum TowerMode { PLACING, WARMUP, FIRING, UPGRADING }

@export_range(1, 10)
var price: int = 1

@onready var range_node = $Range
@onready var range_sprite = $Range/RangeSprite
@onready var selection_node = $Selection
@onready var levels_node = $Levels

var path: Path
var tower_mode = TowerMode.PLACING
var is_selected = false
var is_valid_location = false

signal on_placed(tower: Tower)
signal on_upgrade_start(tower: Tower, next_level: TowerLevel)
signal on_selected(tower: Tower)
signal on_deselected

func _ready():
	is_valid_location = true
	deselect()

func _process(delta):
	if is_placing():
		position = get_viewport().get_mouse_position()

	if is_firing():
		scan(delta)

func set_warming_up():
	tower_mode = TowerMode.WARMUP
	levels_node.start_warmup()

func set_placing():
	tower_mode = TowerMode.PLACING

func is_placing():
	return tower_mode == TowerMode.PLACING

func can_be_placed():
	return is_placing() and is_valid_location

func set_firing():
	tower_mode = TowerMode.FIRING

func is_firing():
	return tower_mode == TowerMode.FIRING

func set_upgrading():
	tower_mode = TowerMode.UPGRADING

func is_upgrading():
	return tower_mode == TowerMode.UPGRADING

func set_default_look():
	range_sprite.modulate = Color.WHITE

func set_error_look():
	range_sprite.modulate = Color.RED

func scan(delta):
	var near_enemy = get_near_enemy()
	if near_enemy:
		levels_node.point_towards_enemy(near_enemy, delta)

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

func get_range_px():
	# 1 range => 100px
	return levels_node.get_current_level().stats.range * 100

func select():
	selection_node.show()
	range_node.show()
	is_selected = true

	on_selected.emit(self)

func deselect():
	selection_node.hide()
	range_node.hide()
	is_selected = false

	on_deselected.emit()

func sell():
	queue_free()

func get_upgrade():
	return levels_node.get_upgrade()

func upgrade():
	var next_level = levels_node.start_upgrade()
	if next_level:
		set_upgrading()

	return next_level

func _on_collision_area_mouse_entered():
	range_node.show()

func _on_collision_area_mouse_exited():
	if not is_selected:
		range_node.hide()

func _on_collision_area_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	if event.is_pressed():
		if can_be_placed():
			set_warming_up()
			on_placed.emit(self)

		if tower_mode == TowerMode.FIRING:
			select()

func _on_barrel_shoot():
	if tower_mode != TowerMode.FIRING:
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

func _on_levels_warmed_up():
	print("Gun tower warmup finished")
	set_firing()

func _on_levels_upgraded():
	print("Gun tower upgrade finished")
	set_firing()

func _on_collision_area_area_entered(_area:Area2D):
	print("Gun tower entered path area")
	is_valid_location = false
	set_error_look()

func _on_collision_area_area_exited(_area:Area2D):
	print("Gun tower exited path area")
	is_valid_location = true
	set_default_look()
