class_name UpgradeTowerButtonState
extends Node

signal state_transition_requested(new_state: UpgradeTowerButton.State, state_data: UpgradeTowerButtonStateData)

var _button: UpgradeTowerButton = null
var _state_data: UpgradeTowerButtonStateData = null
var _appearance: UpgradeTowerButtonAppearance = null

var _upgrade_level: TowerLevel = null

func setup(
	button: UpgradeTowerButton,
	state_data: UpgradeTowerButtonStateData,
	appearance: UpgradeTowerButtonAppearance,
) -> void:
	_button = button
	_state_data = state_data
	_appearance = appearance

func transition_state(
	new_state: UpgradeTowerButton.State,
	state_data := UpgradeTowerButtonStateData.new(),
) -> void:
	state_transition_requested.emit(new_state, state_data)

func resolve_state(money := BankManager.get_money()) -> void:
	if _upgrade_level:
		if _upgrade_level.price <= money:
			transition_state(UpgradeTowerButton.State.ENABLED, create_state_data())
		else:
			transition_state(UpgradeTowerButton.State.DISABLED, create_state_data())
	else:
		transition_state(UpgradeTowerButton.State.UNAVAILABLE, create_state_data())

func create_state_data() -> UpgradeTowerButtonStateData:
	return UpgradeTowerButtonStateData.build().with_upgrade_level(_upgrade_level)

func set_upgrade_level(tower: Tower) -> void:
	if tower:
		_upgrade_level = tower.get_upgrade(_button.upgrade_index)
	else:
		_upgrade_level = null

	if _upgrade_level:
		Logger.info("%s does have upgrade index=%d" % [tower.name, _button.upgrade_index])
	else:
		if tower:
			Logger.info("%s does NOT have upgrade index=%d" % [tower.name, _button.upgrade_index])
		else:
			Logger.info("No tower is selected, disabling %s" % get_button_name())

	resolve_state()

func get_button_name() -> String:
	return "UpgradeTowerButton%d" % _button.upgrade_index
