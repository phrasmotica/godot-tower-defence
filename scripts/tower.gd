class_name Tower extends Node2D

enum TowerMode { PLACING, WARMUP, FIRING, UPGRADING }

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
var is_selected = false
var is_valid_location = false

signal on_placed(tower: Tower)
signal on_upgrade_finish(tower: Tower, next_level: TowerLevel)
signal on_selected(tower: Tower)
signal on_deselected

func _ready():
	is_valid_location = true
	deselect()

	if is_placing():
		range_node.show()

func _process(delta):
	if is_placing():
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
	var near_enemy = get_near_enemy()
	if near_enemy:
		levels_node.point_towards_enemy(near_enemy, delta)

func get_near_enemy():
	var enemies = path.enemies
	if enemies.size() <= 0:
		return null

	var valid_enemies = enemies.filter(func(e): return e != null and not e.is_queued_for_deletion())
	if valid_enemies.size() <= 0:
		return null

	var shooting_range = get_range_px()

	var in_range_enemies = valid_enemies.filter(
		func(e):
			return get_distance_to_enemy(e) <= shooting_range
	)

	if in_range_enemies.size() <= 0:
		return null

	# nearest enemies first
	in_range_enemies.sort_custom(
		func(e, f):
			return get_distance_to_enemy(e) > get_distance_to_enemy(f)
	)

	return in_range_enemies[0]

func get_distance_to_enemy(enemy: Enemy):
	return global_position.distance_to(enemy.global_position)

func get_range_px():
	# 1 range => 100px
	return levels_node.get_current_level().stats.projectile_range * 100

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
	animation_player.play("sell")
	return get_sell_price()

func get_sell_price():
	var upgrade_value = levels_node.get_total_value()
	return int((price + upgrade_value) / 2)

func get_upgrade():
	return levels_node.get_upgrade()

func upgrade():
	var next_level = levels_node.start_upgrade()
	if next_level:
		set_upgrading()

	return next_level

func _on_collision_area_mouse_entered():
	if not is_placing():
		range_node.show()

func _on_collision_area_mouse_exited():
	if not is_placing() and not is_selected:
		range_node.hide()

func _on_collision_area_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	if event.is_pressed():
		if can_be_placed():
			set_warming_up()
			on_placed.emit(self)

		if is_firing():
			select()

func _on_barrel_shoot():
	if not is_firing():
		return

	if not levels_node.should_shoot():
		return

	var level = levels_node.get_current_level()
	print("Current level is " + level.name)

	var projectile = level.stats.projectile

	var bullet: Projectile = projectile.instantiate()
	bullet.damage = level.stats.damage
	bullet.effective_range = level.stats.projectile_range
	bullet.direction = Vector2.RIGHT.rotated(levels_node.rotation)
	bullet.speed = level.stats.projectile_speed

	print("Projectile now has damage " + str(bullet.damage))

	add_child(bullet)

func _on_levels_warmed_up():
	print("Gun tower warmup finished")
	barrel.set_timeout(1.0 / levels_node.get_current_level().stats.fire_rate)
	set_firing()

func _on_levels_upgraded(new_level: TowerLevel):
	print("Gun tower upgrade finished")
	barrel.set_timeout(1.0 / new_level.stats.fire_rate)
	set_firing()

	on_upgrade_finish.emit(self, new_level)

func _on_collision_area_area_entered(_area:Area2D):
	print("Gun tower entered path area")
	is_valid_location = false
	set_error_look()

func _on_collision_area_area_exited(_area:Area2D):
	print("Gun tower exited path area")
	is_valid_location = true
	set_default_look()
