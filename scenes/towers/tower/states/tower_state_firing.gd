class_name TowerStateFiring
extends TowerState

var _effect_factory := EffectFactory.new()
var _projectile_factory := ProjectileFactory.new()

func _enter_tree() -> void:
	print("Tower is now firing")

	_appearance.for_firing()

	_interaction.mouse_entered.connect(_on_mouse_entered)
	_interaction.mouse_exited.connect(_on_mouse_exited)
	_interaction.clicked.connect(_on_clicked)

	_interaction.enable_mouse()

	_weaponry.bolt_created.connect(_on_bolt_created)
	_weaponry.effect_requested.connect(_on_effect_requested)
	_weaponry.shoot_requested.connect(_on_shoot_requested)

	_weaponry.for_firing(_tower)

func _process(delta: float) -> void:
	_appearance.rotation = _weaponry.scan(delta)

func _on_shoot_requested(tower_level: TowerLevel) -> void:
	var projectile := _projectile_factory.create(
		tower_level.projectile_stats,
		_appearance.rotation)

	_appearance.animate_shoot()

	_tower.emit_projectile_created(projectile)

func _on_effect_requested(effect_stats: EffectStats, enemies: Array[Enemy]) -> void:
	for enemy: Enemy in enemies:
		var effect := _effect_factory.create(effect_stats)
		effect.enemy = enemy

		if effect.can_act():
			enemy.add_child(effect)
			effect.start_timer()

	_appearance.animate_pulse()

func _on_bolt_created(bolt_line: BoltLine) -> void:
	print("Adding bolt as child")

	bolt_line.rotation = _appearance.rotation
	bolt_line.fire()

	_appearance.animate_shoot()

	_tower.emit_bolt_created(bolt_line)

func _on_mouse_entered() -> void:
	_appearance.show_visualiser()

func _on_mouse_exited() -> void:
	if not _interaction.is_selected():
		_appearance.hide_visualiser()

func _on_clicked() -> void:
	if not _interaction.is_selected():
		TowerEvents.emit_tower_selected(_tower)

func can_be_selected() -> bool:
	return true
