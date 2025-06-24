class_name TowerWeaponry
extends Node

enum TargetMode { NEAR, FAR, STRONG }

@export
var level_manager: TowerLevelManager

@export
var barrel: GunBarrel

@export
var effect_area: EffectArea

@export
var firing_line: FiringLine

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

func start_warmup() -> void:
	level_manager.start_warmup()

func install_base() -> TowerLevel:
	var first_level := level_manager.finish_warmup()

	barrel.setup(first_level)

	adjust_range(first_level.get_range(true))

	return first_level

func get_target_mode() -> TargetMode:
	return _target_mode

func set_target_mode(target_mode: TargetMode) -> void:
	_target_mode = target_mode

func adjust_range(projectile_range: float) -> void:
	level_manager.level_adjust_range(projectile_range)
	level_manager.level_adjust_effect_range(projectile_range)

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

func scan(delta: float) -> void:
	var near_enemy := _enemy_finder.get_near_enemy(false)
	if near_enemy:
		level_manager.point_towards_enemy(near_enemy, delta)

func _on_barrel_shoot() -> void:
	var in_range_enemies := _enemy_finder.get_near_enemies(false)
	if in_range_enemies.size() <= 0:
		return

	var level := level_manager.get_current_level()
	var projectile := level.create_projectile()

	var rotation := level_manager.rotation

	projectile.direction = Vector2.RIGHT.rotated(rotation)
	projectile.rotation = rotation

	projectile_created.emit(projectile)

func _on_barrel_pulse() -> void:
	var in_range_enemies := _enemy_finder.get_near_enemies(true)
	if not should_create_effect(in_range_enemies):
		return

	var level := level_manager.get_current_level()
	var effect := level.create_effect()

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

	bolt_line.rotation = level_manager.rotation
	bolt_line.fire()

	bolt_created.emit(bolt_line)

func should_bolt(_enemies: Array[Enemy]) -> bool:
	if firing_line:
		return firing_line.enabled && firing_line.can_see_enemies()

	return false
