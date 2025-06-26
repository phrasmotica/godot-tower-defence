class_name TowerWeaponry
extends Node2D

enum TargetMode { NEAR, FAR, STRONG }

@export
var level_manager: TowerLevelManager

@export
var barrel: GunBarrel

@export
var effect_area: EffectArea

@export
var firing_line: FiringLine

var _effect_factory := EffectFactory.new()
var _projectile_factory := ProjectileFactory.new()

var _enemy_finder: EnemyFinder = null
var _target_mode := TargetMode.NEAR

signal projectile_created(projectile: Projectile)
signal effect_created(effect: Effect, enemies: Array[Enemy])
signal bolt_created(bolt_line: BoltLine)

func _ready() -> void:
	barrel.shoot.connect(_on_barrel_shoot)
	barrel.pulse.connect(_on_barrel_pulse)
	barrel.bolt.connect(_on_barrel_bolt)

func pause() -> void:
	barrel.pause()

func install_base() -> TowerLevel:
	var first_level := level_manager.get_current_level()

	barrel.setup(first_level)

	adjust_range(first_level.get_range(true))

	return first_level

func get_target_mode() -> TargetMode:
	return _target_mode

func set_target_mode(target_mode: TargetMode) -> void:
	_target_mode = target_mode

func adjust_range(projectile_range: float) -> void:
	if effect_area:
		effect_area.radius = projectile_range

	if firing_line:
		firing_line.shooting_range = projectile_range

func get_upgrade(index: int) -> TowerLevel:
	return level_manager.get_upgrade(index)

func start_upgrade(index: int) -> TowerLevel:
	return level_manager.start_upgrade(index)

func install_upgrade() -> TowerLevel:
	var next_level := level_manager.finish_upgrade()

	barrel.setup(next_level)

	adjust_range(next_level.get_range(true))

	return next_level

func get_total_value() -> int:
	return level_manager.get_total_value()

func for_firing(tower: Tower) -> void:
	_enemy_finder = EnemyFinder.new(tower, self, level_manager)

func scan(delta: float, tower_pos: Vector2) -> float:
	var new_rotation := rotation

	var near_enemy := _enemy_finder.get_near_enemy(false)
	if near_enemy:
		new_rotation = point_towards_enemy(tower_pos, near_enemy, delta)

	rotation = new_rotation

	return rotation

func _on_barrel_shoot() -> void:
	var in_range_enemies := _enemy_finder.get_near_enemies(false)
	if in_range_enemies.size() <= 0:
		return

	var level := level_manager.get_current_level()
	if not level.projectile_stats:
		return

	var projectile := _projectile_factory.create(level.projectile_stats)

	projectile_created.emit(projectile)

func _on_barrel_pulse() -> void:
	var in_range_enemies := _enemy_finder.get_near_enemies(true)
	if not should_create_effect(in_range_enemies):
		return

	var level := level_manager.get_current_level()
	if not level.effect_stats:
		return

	var effect := _effect_factory.create(level.effect_stats)
	add_child(effect)

	effect_created.emit(effect, in_range_enemies)

func should_create_effect(enemies: Array[Enemy]) -> bool:
	if effect_area:
		return effect_area.enabled and enemies.size() > 0

	return false

func _on_barrel_bolt() -> void:
	var in_range_enemies := _enemy_finder.get_near_enemies(false)

	if not should_bolt(in_range_enemies):
		return

	var level := level_manager.get_current_level()

	print("Processing bolt")

	var bolt_line := firing_line.fire(level.projectile_stats)

	bolt_created.emit(bolt_line)

func should_bolt(_enemies: Array[Enemy]) -> bool:
	if firing_line:
		return firing_line.enabled && firing_line.can_see_enemies()

	return false

# TODO: put this in a new TowerAiming script
func point_towards_enemy(tower_pos: Vector2, enemy: Enemy, delta: float) -> float:
	var current_level := level_manager.get_current_level()
	if not current_level.point_towards_enemy:
		return rotation

	var rotate_speed = current_level.projectile_stats.rotate_speed

	# gets the angle we want to face
	var angle_to_enemy := tower_pos.direction_to(enemy.global_position).angle()

	# ensure rotation is in the range (-180, 180]
	while angle_to_enemy > PI:
		angle_to_enemy -= (2 * PI)

	# slowly changes the rotation to face the angle
	var new_rotation = rotate_toward(rotation, angle_to_enemy, delta * rotate_speed)
	return new_rotation
