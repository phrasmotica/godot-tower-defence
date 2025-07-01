@tool
class_name CreateTowerButton extends Button

enum State { DISABLED, CANNOT_AFFORD, ENABLED, CREATING }

@export
var tower: PackedScene

@export
var action_name: StringName

@export
var tooltip: Control

@export
var name_text: Label

@export
var price_text: Label

@export
var description_text: Label

@export
var show_tooltip := false:
	set(value):
		tooltip.visible = value

	get:
		return tooltip.visible

var tower_price := 0

var original_icon: Texture2D

var _state_factory := CreateTowerButtonStateFactory.new()
var _current_state: CreateTowerButtonState = null

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	if tower:
		original_icon = icon

		var dummy_tower: Tower = tower.instantiate()

		tower_price = dummy_tower.price

		# prefer this to a tooltip so that we can control its appearance
		# by mouse enter/exit events rather than by the mouse being idle
		name_text.text = dummy_tower.tower_name
		price_text.text = "Price: " + str(dummy_tower.price)
		description_text.text = dummy_tower.tower_description

	BankManager.money_changed.connect(_on_bank_manager_money_changed)

	GameEvents.game_started.connect(_on_game_events_game_started)

	switch_state(State.DISABLED)

func switch_state(state: State, state_data := CreateTowerButtonStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "CreateTowerButtonStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func _on_bank_manager_money_changed(money: int) -> void:
	# TODO: only do these transitions if we are not already in those states
	if tower_price > money:
		switch_state(State.CANNOT_AFFORD)
	else:
		switch_state(State.ENABLED)

func _on_game_events_game_started(_path_index: int) -> void:
	switch_state(State.ENABLED)
