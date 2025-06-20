@tool
class_name TowerLevelManager extends Node2D

const normal_colour := Color.WHITE

@export
var progress_colour := Color8(255, 255, 255, 80)

@export
var effect_area: EffectArea

@export
var firing_line: FiringLine

@export
var base_level: TowerLevel:
	set(value):
		print("Base level")
		base_level = value

		# MEDIUM: allow choosing which level the visualiser should visualise
		if not base_level.adjust_range.is_connected(level_adjust_range):
			base_level.adjust_range.connect(level_adjust_range)

		if not base_level.adjust_effect_range.is_connected(level_adjust_effect_range):
			base_level.adjust_effect_range.connect(level_adjust_effect_range)

var upgrade_path: Array[int] = []

var ongoing_upgrade_index := -1

signal warmed_up(first_level: TowerLevel)
signal upgraded(new_level: TowerLevel)

signal adjust_range(range: float)
signal adjust_effect_range(range: float)

signal created_projectile(projectile: Projectile)
signal created_effect(effect: Effect)
signal created_bolt(stats: TowerLevelStats)

func warmup_started():
	base_level.modulate = progress_colour

func warmup_finished():
	base_level.modulate = normal_colour

	base_level.created_projectile.connect(_on_level_created_projectile)
	base_level.created_effect.connect(_on_level_created_effect)
	base_level.created_bolt.connect(_on_level_created_bolt)

	warmed_up.emit(base_level)

func start_upgrade(index: int) -> TowerLevel:
	var next_level = get_upgrade(index)

	if next_level:
		ongoing_upgrade_index = index

	return next_level

func upgrade_started():
	base_level.modulate = progress_colour

func upgrade_finished():
	if ongoing_upgrade_index < 0 or not get_upgrade(ongoing_upgrade_index):
		return

	# hide old level
	var old_level = get_current_level()

	if old_level.created_projectile.is_connected(_on_level_created_projectile):
		print("Disconnecting _on_level_created_projectile")
		old_level.created_projectile.disconnect(_on_level_created_projectile)

	if old_level.created_effect.is_connected(_on_level_created_effect):
		print("Disconnecting _on_level_created_effect")
		old_level.created_effect.disconnect(_on_level_created_effect)

	if old_level.created_bolt.is_connected(_on_level_created_bolt):
		print("Disconnecting _on_level_created_bolt")
		old_level.created_bolt.disconnect(_on_level_created_bolt)

	upgrade_path.append(ongoing_upgrade_index)
	ongoing_upgrade_index = -1

	var new_level = get_current_level()

	new_level.visible = true

	new_level.created_projectile.connect(_on_level_created_projectile)
	new_level.created_effect.connect(_on_level_created_effect)
	new_level.created_bolt.connect(_on_level_created_bolt)

	base_level.modulate = normal_colour

	upgraded.emit(new_level)

func get_upgrade(index: int):
	return base_level.get_upgrade(upgrade_path, index)

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

func level_adjust_range(projectile_range: float):
	print("Level adjusting projectile range")

	if firing_line:
		firing_line.shooting_range = projectile_range

	adjust_range.emit(projectile_range)

func level_adjust_effect_range(effect_range: float):
	print("Level adjusting effect range")

	if effect_area:
		effect_area.radius = effect_range

	adjust_effect_range.emit(effect_range)

func should_create_effect(enemies: Array[Enemy]):
	if effect_area:
		return effect_area.enabled and enemies.size() > 0

	return false

func should_bolt(_enemies: Array[Enemy]):
	if firing_line:
		return firing_line.enabled && firing_line.can_see_enemies()

	return false

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

	created_bolt.emit(bolt_stats)

func _on_progress_bars_warmup_started():
	warmup_started()

func _on_progress_bars_warmup_finished():
	warmup_finished()

func _on_progress_bars_upgrade_started():
	upgrade_started()

func _on_progress_bars_upgrade_finished():
	upgrade_finished()
