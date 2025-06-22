class_name Tower extends Node2D

enum State { PLACING, WARMUP, FIRING, UPGRADING, SELLING, DISABLED }

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
var appearance: TowerAppearance = %Appearance

@onready
var collision_area: Area2D = %CollisionArea

@onready var selection: TowerSelection = $Selection
@onready var progress_bars: TowerProgressBars = $ProgressBars
@onready var levels_node: TowerLevelManager = $Levels
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var barrel: GunBarrel = $Barrel

var path_manager: PathManager

var _state_factory := TowerStateFactory.new()
var _current_state: TowerState = null

func _ready() -> void:
	switch_state(State.PLACING)

func switch_state(state: State, state_data := TowerStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		appearance,
		collision_area,
		levels_node,
		selection,
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

func is_upgrading() -> bool:
	return _current_state != null and _current_state.is_upgrading()

func set_disabled() -> void:
	switch_state(State.DISABLED)

func select() -> void:
	if _current_state != null and _current_state.can_be_selected():
		_current_state.select()

func deselect() -> void:
	if _current_state != null and _current_state.can_be_selected():
		_current_state.deselect()

func set_target_mode(index: int):
	target_mode = index as TargetMode
	print(tower_name + " now has target mode " + str(target_mode))

func upgrade(index: int) -> void:
	switch_state(State.UPGRADING, TowerStateData.build().with_upgrade_index(index))

func get_upgrade(index: int):
	return levels_node.get_upgrade(index)

func sell() -> void:
	switch_state(State.SELLING)

func get_sell_price():
	var upgrade_value = levels_node.get_total_value()
	return int((price + upgrade_value) / 2.0)
