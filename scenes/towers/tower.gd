class_name Tower extends Node2D

enum State { PLACING, WARMUP, FIRING, UPGRADING, SELLING, DISABLED }

@export
var tower_name := ""

@export_multiline
var tower_description := ""

@export_range(1, 10)
var price: int = 1

@export
var starting_target_mode := TowerWeaponry.TargetMode.NEAR

@onready
var appearance: TowerAppearance = %Appearance

@onready
var colliders: TowerColliders = %Colliders

@onready
var designer: TowerDesigner = %Designer

@onready
var interaction: TowerInteraction = %Interaction

@onready
var weaponry: TowerWeaponry = %Weaponry

var _info: TowerInfo = null

var _state_factory := TowerStateFactory.new()
var _current_state: TowerState = null

signal projectile_created(projectile: Node2D)
signal bolt_created(bolt_line: BoltLine)

func _ready() -> void:
	_info = TowerInfo.new(tower_name, price)

	weaponry.set_target_mode(starting_target_mode)

func switch_state(state: State, state_data := TowerStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		appearance,
		colliders,
		_info,
		interaction,
		weaponry)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "TowerStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func clear_state() -> void:
	if _current_state != null:
		remove_child(_current_state)

func is_upgrading() -> bool:
	return _current_state != null and _current_state.is_upgrading()

func set_disabled() -> void:
	switch_state(State.DISABLED)

func emit_projectile_created(projectile: Node2D) -> void:
	projectile.global_position = global_position
	projectile_created.emit(projectile)

func emit_bolt_created(bolt_line: BoltLine) -> void:
	bolt_line.global_position = global_position
	bolt_created.emit(bolt_line)

func select() -> void:
	if _current_state != null and _current_state.can_be_selected():
		_current_state.select()

func deselect() -> void:
	if _current_state != null and _current_state.can_be_selected():
		_current_state.deselect()

func set_target_mode(target_mode: TowerWeaponry.TargetMode) -> void:
	weaponry.set_target_mode(target_mode)
	print(tower_name + " now has target mode " + str(target_mode))

func upgrade(index: int) -> void:
	switch_state(State.UPGRADING, TowerStateData.build().with_upgrade_index(index))

func get_upgrade(index: int) -> TowerLevel:
	return weaponry.get_upgrade(index)

func sell() -> void:
	switch_state(State.SELLING)

func get_sell_price() -> int:
	var upgrade_value = weaponry.get_total_value()
	return int((price + upgrade_value) / 2.0)
