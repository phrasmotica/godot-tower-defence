class_name Tower extends Node2D

enum TowerMode { PLACING, WARMUP, FIRING, UPGRADING }

@export
var tower_name := ""

# TODO: remove this, set it on the first tower level instead
@export_multiline
var tower_description := ""

@export_range(1, 10)
var price: int = 1

@onready var range_node = $Range
@onready var range_sprite = $Range/RangeSprite
@onready var selection_node = $Selection
@onready var levels_node = $Levels
@onready var animation_player: AnimationPlayer = $Levels/AnimationPlayer
@onready var barrel: GunBarrel = $Barrel

var path: Path
var tower_mode = TowerMode.PLACING
var just_placed := false
var is_selected = false
var is_valid_location = false

signal on_placed(tower: Tower)
signal on_warmed_up(tower: Tower, first_level: TowerLevel)
signal on_upgrade_finish(tower: Tower, next_level: TowerLevel)
signal on_selected(tower: Tower)
signal on_deselected

func _ready():
	is_valid_location = true
	deselect()

	adjust_range(levels_node.get_current_level().stats.projectile_range)

	if is_placing():
		range_node.show()

func _process(delta):
	if is_placing():
		if not visible:
			show()

		global_position = get_viewport().get_mouse_position()

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
	var near_enemy = get_near_enemy(false)
	if near_enemy:
		levels_node.point_towards_enemy(near_enemy, delta)

func get_near_enemies(for_effect: bool) -> Array[Enemy]:
	var enemies = path.enemies
	if enemies.size() <= 0:
		return []

	var valid_enemies = enemies.filter(func(e): return e != null and not e.is_queued_for_deletion())
	if valid_enemies.size() <= 0:
		return []

	var shooting_range = get_range_px(for_effect)

	var in_range_enemies = valid_enemies.filter(
		func(e):
			return e.get_distance_to(global_position) <= shooting_range
	)

	if in_range_enemies.size() <= 0:
		return []

	# nearest enemies first
	in_range_enemies.sort_custom(
		func(e, f):
			return e.get_distance_to(global_position) < f.get_distance_to(global_position)
	)

	return in_range_enemies

func get_near_enemy(for_effect: bool):
	var enemies = get_near_enemies(for_effect)
	return enemies[0] if enemies.size() > 0 else null

func get_range_px(for_effect: bool):
	var current_level = levels_node.get_current_level()
	var actual_range = current_level.get_range(for_effect)

	# 1 range => 100px
	return actual_range * 100

func select():
	selection_node.show()
	range_node.show()
	is_selected = true

func deselect():
	selection_node.hide()
	range_node.hide()
	is_selected = false

	on_deselected.emit()

func sell():
	animation_player.play("sell")
	return get_sell_price()

func get_sell_price():
	var upgrade_value = levels_node.get_total_value()
	return int((price + upgrade_value) / 2)

func get_upgrade(index: int):
	return levels_node.get_upgrade(index)

func upgrade(index: int):
	barrel.pause()

	var next_level = levels_node.start_upgrade(index)
	if next_level:
		set_upgrading()

	return next_level

func adjust_range(projectile_range: int):
	var range_scale := float(projectile_range) / 10
	range_sprite.scale = Vector2(range_scale, range_scale)

	levels_node.adjust_range(projectile_range)

func _on_detect_mouse_mouse_entered():
	if not is_placing():
		range_node.show()

func _on_detect_mouse_mouse_exited():
	# this fires before mouse_entered after we have just placed the tower,
	# so make sure we don't hide the range right after placing the tower
	if not is_placing() and not just_placed and not is_selected:
		range_node.hide()

	if just_placed:
		just_placed = false

func _on_detect_mouse_gui_input(event: InputEvent):
	if event.is_pressed():
		if can_be_placed():
			just_placed = true

			set_warming_up()
			on_placed.emit(self)

		if is_firing() and not is_selected:
			on_selected.emit(self)

func _on_barrel_shoot():
	if not is_firing():
		return

	if not levels_node.should_shoot():
		return

	var level = levels_node.get_current_level()

	level.try_create_projectile()

func _on_barrel_pulse():
	if not is_firing():
		return

	var in_range_enemies = get_near_enemies(true)
	if not levels_node.should_create_effect(in_range_enemies):
		return

	var level = levels_node.get_current_level()

	level.try_create_effect()

func _on_barrel_bolt():
	if not is_firing():
		return

	if not levels_node.should_shoot():
		return

	var level = levels_node.get_current_level()

	level.try_shoot_bolt()

func _on_levels_warmed_up(first_level: TowerLevel):
	print(tower_name + " warmup finished")

	barrel.setup(first_level)

	set_firing()

	on_warmed_up.emit(self, first_level)

func _on_levels_upgraded(new_level: TowerLevel):
	print(tower_name + " upgrade finished")

	barrel.setup(new_level)

	adjust_range(new_level.stats.projectile_range)

	set_firing()

	on_upgrade_finish.emit(self, new_level)

func _on_collision_area_area_entered(_area:Area2D):
	print(tower_name + " entered path area")
	is_valid_location = false
	set_error_look()

func _on_collision_area_area_exited(_area:Area2D):
	print(tower_name + " exited path area")
	is_valid_location = true
	set_default_look()

func _on_levels_created_projectile(projectile: Projectile):
	print("Adding projectile as child")

	add_child(projectile)

func _on_levels_created_effect(effect: Effect):
	var enemies := get_near_enemies(true)
	var valid_enemies := enemies.filter(func(e): return effect.can_act(e))

	if valid_enemies.size() > 0:
		print("Passing effect to enemies")

		effect.attached_enemies = enemies
		effect.act_start()

func _on_levels_created_bolt():
	print("Affecting all enemies in firing line")
