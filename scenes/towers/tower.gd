class_name Tower extends Node2D

enum State { PLACING, WARMUP, FIRING, UPGRADING, DISABLED }

enum TargetMode { NEAR, FAR, STRONG }

@export
var tower_name := ""

@export_multiline
var tower_description := ""

@export_range(1, 10)
var price: int = 1

@export
var target_mode := TargetMode.NEAR

@export
var firing_line: FiringLine

@onready
var collision_area: Area2D = %CollisionArea

@onready var selection: TowerSelection = $Selection
@onready var visualiser: TowerVisualiser = $Visualiser
@onready var progress_bars: TowerProgressBars = $ProgressBars
@onready var levels_node: TowerLevelManager = $Levels
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var barrel: GunBarrel = $Barrel

var path_manager: PathManager
var tower_mode = State.PLACING
var is_selected = false
var enemy_sorter = EnemySorter.new()

var _state_factory := TowerStateFactory.new()
var _current_state: TowerState = null

signal on_upgrade_finish(tower: Tower, next_level: TowerLevel)

func _ready() -> void:
	switch_state(State.PLACING)

func switch_state(state: State, state_data := TowerStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		collision_area,
		levels_node,
		selection,
		visualiser,
		progress_bars,
		path_manager,
		barrel,
		firing_line,
		animation_player)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "TowerStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func is_placing() -> bool:
	return _current_state != null and _current_state.is_placing()

func can_be_placed() -> bool:
	return _current_state != null and _current_state.can_be_placed()

func set_upgrading():
	tower_mode = State.UPGRADING

func is_upgrading():
	return tower_mode == State.UPGRADING

func set_disabled():
	tower_mode = State.DISABLED

func select() -> void:
	selection.selection_visible = true
	visualiser.show_range()
	is_selected = true

func deselect() -> void:
	selection.selection_visible = false
	visualiser.hide_range()
	is_selected = false

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

func _on_levels_upgraded(new_level: TowerLevel):
	print(tower_name + " upgrade finished")

	barrel.setup(new_level)

	adjust_range(new_level.get_range(true))

	on_upgrade_finish.emit(self, new_level)
