class_name TowerLevelManager extends Node2D

@onready var firing_line: RayCast2D = $FiringLine
@onready var effect_area: Area2D = $EffectArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var levels: Array[TowerLevel]

var level_index = 0

signal warmed_up
signal upgraded(new_level: TowerLevel)

signal created_projectile(projectile: Projectile)

func _ready():
	for level in levels:
		level.created_projectile.connect(_on_level_created_projectile)

func start_warmup():
	animation_player.play("warmup")

func warmup_finished():
	warmed_up.emit()

func start_upgrade() -> TowerLevel:
	var next_level = get_upgrade()

	if next_level:
		animation_player.play("upgrade")

	return next_level

func upgrade_finished():
	if not get_upgrade():
		return

	level_index += 1

	levels[level_index - 1].visible = false
	levels[level_index].visible = true

	upgraded.emit(levels[level_index])

func get_upgrade():
	if level_index < levels.size() - 1:
		return levels[level_index + 1]

	return null

func should_shoot():
	if firing_line.enabled:
		return firing_line.is_colliding()

	if effect_area.monitoring:
		# TODO: check in-range enemies using signals from the effect area instead
		return effect_area.get_overlapping_areas().size() > 0

	return false

func get_current_level() -> TowerLevel:
	return levels[level_index]

func get_total_value():
	if level_index <= 0 or levels.size() < 2:
		return 0

	# return sum of prices of purchased upgrades
	return (
		levels
			.slice(1, level_index + 1)
			.map(func(level): return level.price)
			.reduce(func(a, b): return a + b)
	)

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

	created_projectile.emit(projectile)
