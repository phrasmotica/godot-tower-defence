@tool
class_name TowerLevelManager extends Node2D

@export
var range_node: RangeArea

@export
var firing_line: FiringLine

@export
var effect_area: EffectArea

@export var base_level: TowerLevel:
	set(value):
		print("Base level")
		base_level = value

		# TODO: connect these to the base level's upgrades too, recursively
		if not base_level.adjust_range.is_connected(adjust_range):
			base_level.adjust_range.connect(adjust_range)

		if not base_level.adjust_effect_range.is_connected(adjust_effect_range):
			base_level.adjust_effect_range.connect(adjust_effect_range)

var upgrade_path: Array[int] = []

var ongoing_upgrade_index := -1

signal warmed_up(first_level: TowerLevel)
signal upgraded(new_level: TowerLevel)

signal created_projectile(projectile: Projectile)
signal created_effect(effect: Effect)
signal created_bolt

func set_default_look():
	if range_node:
		range_node.set_default_look()

func set_error_look():
	if range_node:
		range_node.set_error_look()

func warmup_finished():
	base_level.created_projectile.connect(_on_level_created_projectile)
	base_level.created_effect.connect(_on_level_created_effect)
	base_level.created_bolt.connect(_on_level_created_bolt)

	warmed_up.emit(base_level)

func start_upgrade(index: int) -> TowerLevel:
	var next_level = get_upgrade(index)

	if next_level:
		ongoing_upgrade_index = index

	return next_level

func upgrade_finished():
	if ongoing_upgrade_index < 0 or not get_upgrade(ongoing_upgrade_index):
		return

	# hide old level
	var old_level = get_current_level()

	if old_level.created_projectile.is_connected(_on_level_created_projectile):
		print("Disconnecting _on_level_created_projectile")
		old_level.created_projectile.disconnect(_on_level_created_projectile)

	if old_level.created_projectile.is_connected(_on_level_created_effect):
		print("Disconnecting _on_level_created_effect")
		old_level.created_effect.disconnect(_on_level_created_effect)

	if old_level.created_projectile.is_connected(_on_level_created_bolt):
		print("Disconnecting _on_level_created_bolt")
		old_level.created_bolt.disconnect(_on_level_created_bolt)

	upgrade_path.append(ongoing_upgrade_index)
	ongoing_upgrade_index = -1

	var new_level = get_current_level()

	new_level.visible = true

	new_level.created_projectile.connect(_on_level_created_projectile)
	new_level.created_effect.connect(_on_level_created_effect)
	new_level.created_bolt.connect(_on_level_created_bolt)

	upgraded.emit(new_level)

func get_upgrade(index: int):
	return base_level.get_upgrade(upgrade_path, index)

func should_shoot():
	if firing_line.enabled:
		return firing_line.can_see_enemies()

	return false

func should_create_effect(enemies: Array[Enemy]):
	if effect_area.enabled:
		return enemies.size() > 0

	return false

func get_current_level() -> TowerLevel:
	return base_level.get_current_level(upgrade_path)

func get_total_value() -> int:
	return base_level.get_total_value(upgrade_path)

func point_towards_enemy(enemy: Enemy, delta: float):
	var current_level := get_current_level()
	if not current_level.point_towards_enemy:
		return

	var rotate_speed = current_level.projectile_stats.rotate_speed

	# gets the angle we want to face
	var angle_to_enemy = global_position.direction_to(enemy.global_position).angle()

	# ensure rotation is in the range (-180, 180]
	while angle_to_enemy > PI:
		angle_to_enemy -= (2 * PI)

	# slowly changes the rotation to face the angle
	var new_rotation = rotate_toward(rotation, angle_to_enemy, delta * rotate_speed)
	rotation = new_rotation

	# ensure the tower sprite does the same
	base_level.rotation = new_rotation

func show_range():
	if range_node:
		range_node.show()

func hide_range():
	if range_node:
		range_node.hide()

func adjust_range(projectile_range: float):
	if range_node:
		range_node.radius = projectile_range

	if firing_line:
		firing_line.shooting_range = projectile_range

func adjust_effect_range(effect_range: float):
	if effect_area:
		effect_area.radius = effect_range

func _on_level_created_projectile(projectile: Projectile):
	print("Rotating projectile")

	projectile.direction = Vector2.RIGHT.rotated(rotation)
	projectile.rotation = rotation

	created_projectile.emit(projectile)

func _on_level_created_effect(effect: Effect):
	print("Processing effect")

	created_effect.emit(effect)

func _on_level_created_bolt(bolt_stats: TowerLevelStats):
	print("Processing bolt")

	firing_line.fire(bolt_stats)

	created_bolt.emit()

func _on_firing_line_created_line(bolt_line:Line2D):
	print("Rotating bolt line")

	bolt_line.rotation = rotation
