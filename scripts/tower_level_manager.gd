class_name TowerLevelManager extends Node2D

@onready var firing_line: RayCast2D = $FiringLine
@onready var effect_area: Area2D = $EffectArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var base_level: TowerLevel

var upgrade_path: Array[int] = []

signal warmed_up(first_level: TowerLevel)
signal upgraded(new_level: TowerLevel)

signal created_projectile(projectile: Projectile)
signal created_effect(effect: Effect)

func start_warmup():
	animation_player.play("warmup")

func warmup_finished():
	base_level.created_projectile.connect(_on_level_created_projectile)
	base_level.created_effect.connect(_on_level_created_effect)

	warmed_up.emit(base_level)

func start_upgrade() -> TowerLevel:
	var next_level = get_upgrade()

	if next_level:
		animation_player.play("upgrade")

	return next_level

func upgrade_finished():
	if not get_upgrade():
		return

	# hide old level
	var old_level = get_current_level()

	if old_level.created_projectile.is_connected(_on_level_created_projectile):
		print("Disconnecting _on_level_created_projectile")
		old_level.created_projectile.disconnect(_on_level_created_projectile)

	if old_level.created_projectile.is_connected(_on_level_created_effect):
		print("Disconnecting _on_level_created_effect")
		old_level.created_effect.disconnect(_on_level_created_effect)

	upgrade_path.append(0)

	var new_level = get_current_level()

	new_level.visible = true

	new_level.created_projectile.connect(_on_level_created_projectile)
	new_level.created_effect.connect(_on_level_created_effect)

	upgraded.emit(new_level)

func get_upgrade():
	return base_level.get_upgrade(upgrade_path)

func should_shoot():
	if firing_line.enabled:
		return firing_line.is_colliding()

	return false

func should_create_effect(enemies: Array[Enemy]):
	if effect_area.monitoring:
		return enemies.size() > 0

	return false

func get_current_level() -> TowerLevel:
	return base_level.get_current_level(upgrade_path)

func get_total_value() -> int:
	return base_level.get_total_value(upgrade_path)

func point_towards_enemy(enemy: Enemy, delta: float):
	var rotate_speed = get_current_level().stats.rotate_speed

	# gets the angle we want to face
	var angle_to_enemy = global_position.direction_to(enemy.global_position).angle()

	# ensure rotation is in the range (-180, 180]
	while angle_to_enemy > PI:
		angle_to_enemy -= (2 * PI)

	# slowly changes the rotation to face the angle
	rotation = move_toward(rotation, angle_to_enemy, delta * rotate_speed)

func adjust_range(projectile_range: int):
	firing_line.target_position = Vector2(projectile_range * 100, 0)

func _on_level_created_projectile(projectile: Projectile):
	print("Rotating projectile")

	projectile.direction = Vector2.RIGHT.rotated(rotation)
	projectile.rotation = rotation

	created_projectile.emit(projectile)

func _on_level_created_effect(effect: Effect):
	print("Processing effect")

	created_effect.emit(effect)
