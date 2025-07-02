@tool
class_name UpgradeTowerButton extends Button

enum State { DISABLED, ENABLED, UNAVAILABLE }

@export
var action_name: StringName

@export
var upgrade_index := 0

@export
var align_tooltip_bottom := false:
	set(value):
		align_tooltip_bottom = value

		if appearance:
			appearance.realign_tooltip()

@onready
var appearance: UpgradeTowerButtonAppearance = %Appearance

var upgrade_level: TowerLevel

var _state_factory := UpgradeTowerButtonStateFactory.new()
var _current_state: UpgradeTowerButtonState = null

# HIGH: eventually we won't need this anymore. But we need it for now because
# the set_upgrade_level method is in this script.
# We need to set it initially to be nonzero, so the money_changed event handler
# is required for now.
var _money_from_bank := 0

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	# HIGH: GRADUALLY move all of this signal handling into the state machine...
	# everything is working now, but it did take a while to figure out all the
	# transitions and whatnot
	BankManager.money_changed.connect(_on_money_changed)

	TowerEvents.selected_tower_changed.connect(_on_selected_tower_changed)
	TowerEvents.tower_deselected.connect(_on_tower_deselected)

	TowerEvents.tower_upgrade_finished.connect(_on_tower_upgrade_finished)

	switch_state(State.UNAVAILABLE)

func switch_state(state: State, state_data := UpgradeTowerButtonStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data,
		appearance)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "UpgradeTowerButtonStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

func _on_money_changed(_old_money: int, new_money: int) -> void:
	_money_from_bank = new_money

func _on_selected_tower_changed(new_tower: Tower, _old_tower: Tower) -> void:
	set_upgrade_level(new_tower)

func _on_tower_deselected() -> void:
	set_upgrade_level(null)

func _on_tower_upgrade_finished(_index: int, tower: Tower, _next_level: TowerLevel) -> void:
	set_upgrade_level(tower)

func set_upgrade_level(tower: Tower) -> void:
	upgrade_level = tower.get_upgrade(upgrade_index) if tower else null

	if upgrade_level:
		print("%s does have upgrade index=%d" % [tower.name, upgrade_index])

		appearance.set_upgrade_level(upgrade_level)

		resolve_state()
	else:
		if tower:
			print("%s does NOT have upgrade index=%d" % [tower.name, upgrade_index])
		else:
			print("No tower is selected, disabling %s" % _current_state.get_button_name())

		switch_state(State.UNAVAILABLE)

func resolve_state() -> void:
	if _current_state != null:
		_current_state.resolve_state(_money_from_bank)
