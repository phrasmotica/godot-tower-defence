class_name Tower extends Node2D

enum TowerMode { PLACING, WARMUP, FIRING, UPGRADING, DISABLED }

enum TargetMode { NEAR, FAR, STRONG }

@export
var tower_name := ""

@export_multiline
var tower_description := ""

@export_range(1, 10)
var price: int = 1

@export
var target_mode := TargetMode.NEAR

@onready var selection: TowerSelection = $Selection
@onready var visualiser: TowerVisualiser = $Visualiser
@onready var progress_bars: TowerProgressBars = $ProgressBars
@onready var levels_node: TowerLevelManager = $Levels
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var barrel: GunBarrel = $Barrel

var path_manager: PathManager
var tower_mode = TowerMode.PLACING
var is_selected = false
var is_valid_location = false
var enemy_sorter = EnemySorter.new()

signal on_placed(tower: Tower)
signal on_warmed_up(tower: Tower, first_level: TowerLevel)
signal on_upgrade_finish(tower: Tower, next_level: TowerLevel)
signal on_selected(tower: Tower)
signal on_deselected

func _ready():
	deselect()

	adjust_range(levels_node.get_current_level().get_range(true))

	if is_placing():
		selection.selection_visible = false

		visualiser.show_range()
		visualiser.show_bolt_line = false

func _process(delta):
	if is_placing():
		if not visible:
			show()

		global_position = get_viewport().get_mouse_position()

	if is_firing():
		scan(delta)

func set_warming_up():
	tower_mode = TowerMode.WARMUP

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

func set_disabled():
	tower_mode = TowerMode.DISABLED

func show_visualiser():
	visualiser.show()

func hide_visualiser():
	visualiser.hide()

func set_default_look():
	visualiser.set_default_look()

func set_error_look():
	visualiser.set_error_look()

func scan(delta):
	var near_enemy = get_near_enemy(false)
	if near_enemy:
		levels_node.point_towards_enemy(near_enemy, delta)

func get_near_enemies(for_effect: bool) -> Array[Enemy]:
	var enemies = path_manager.enemies
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

	match target_mode:
		TargetMode.STRONG:
			enemy_sorter.strong(in_range_enemies)
		TargetMode.FAR:
			enemy_sorter.far(in_range_enemies, global_position)
		_:
			# nearest enemies first by default
			enemy_sorter.near(in_range_enemies, global_position)

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
	selection.selection_visible = true
	visualiser.show_range()
	is_selected = true

func deselect():
	selection.selection_visible = false
	visualiser.hide_range()
	is_selected = false

	on_deselected.emit()

func set_target_mode(index: int):
	target_mode = index as TargetMode
	print(tower_name + " now has target mode " + str(target_mode))

func sell():
	animation_player.play("sell")
	return get_sell_price()

func get_sell_price():
	var upgrade_value = levels_node.get_total_value()
	return int((price + upgrade_value) / 2.0)

func get_upgrade(index: int):
	return levels_node.get_upgrade(index)

func upgrade(index: int):
	barrel.pause()

	var next_level = levels_node.start_upgrade(index)
	if next_level:
		set_upgrading()

		progress_bars.do_upgrade()

	return next_level

func adjust_range(projectile_range: float):
	visualiser.radius = projectile_range

	levels_node.level_adjust_range(projectile_range)
	levels_node.level_adjust_effect_range(projectile_range)

func should_shoot(enemies: Array[Enemy]):
	return enemies.size() > 0

func should_create_effect(enemies: Array[Enemy]):
	return levels_node.should_create_effect(enemies)

func should_bolt(enemies: Array[Enemy]):
	return levels_node.should_bolt(enemies)

func _on_selection_mouse_entered():
	if not is_placing():
		visualiser.show_range()

func _on_selection_mouse_exited():
	if not is_placing() and not is_selected:
		visualiser.hide_range()

func _on_selection_gui_input(event: InputEvent):
	if event.is_pressed():
		if is_firing() and not is_selected:
			on_selected.emit(self)

func try_place():
	if not can_be_placed():
		print("Cannot place tower here!")
		return

	set_warming_up()
	hide_visualiser()
	progress_bars.do_warmup()

	on_placed.emit(self)

func _on_barrel_shoot():
	if not is_firing():
		return

	var in_range_enemies = get_near_enemies(false)
	if not should_shoot(in_range_enemies):
		return

	var level = levels_node.get_current_level()

	level.try_create_projectile()

func _on_barrel_pulse():
	if not is_firing():
		return

	var in_range_enemies = get_near_enemies(true)
	if not should_create_effect(in_range_enemies):
		return

	var level = levels_node.get_current_level()

	level.try_create_effect()

func _on_barrel_bolt():
	if not is_firing():
		return

	var in_range_enemies = get_near_enemies(false)

	if not should_bolt(in_range_enemies):
		return

	var level = levels_node.get_current_level()

	level.try_shoot_bolt()

func _on_levels_warmed_up(first_level: TowerLevel):
	print(tower_name + " warmup finished")

	barrel.setup(first_level)
	selection.enable_mouse()

	set_firing()

	on_warmed_up.emit(self, first_level)

func _on_levels_upgraded(new_level: TowerLevel):
	print(tower_name + " upgrade finished")

	barrel.setup(new_level)

	adjust_range(new_level.get_range(true))

	set_firing()

	on_upgrade_finish.emit(self, new_level)

# NOTE: Area2D handling a collision with a TileSet's physics layer
# must use body_entered/exited rather than area_entered/exited!!
func _on_collision_area_body_entered(_body: Node2D):
	print(tower_name + " entered path area")
	is_valid_location = false
	set_error_look()

func _on_collision_area_body_exited(_body: Node2D):
	print(tower_name + " exited path area")
	is_valid_location = true
	set_default_look()

func _on_levels_created_projectile(projectile: Projectile):
	print("Adding projectile as child")

	animate_shoot()

	# BUG: projectiles get freed when the tower is sold. Probably happens
	# with bolt lines too...
	add_child(projectile)

func _on_levels_created_effect(effect: Effect):
	var enemies := get_near_enemies(true)
	var valid_enemies := enemies.filter(func(e): return effect.can_act(e))

	if valid_enemies.size() > 0:
		print("Passing effect to enemies")

		effect.attached_enemies = enemies
		effect.act_start()

	animate_pulse()

	effect.start_timer()

func _on_firing_line_created_line(bolt_line: BoltLine):
	print("Adding bolt line as child")

	bolt_line.rotation = levels_node.rotation
	bolt_line.fire()

	animate_shoot()

	add_child(bolt_line)

func animate_shoot():
	if animation_player.current_animation.length() <= 0:
		animation_player.play("shoot")

func animate_pulse():
	if animation_player.current_animation.length() <= 0:
		animation_player.play("pulse")
