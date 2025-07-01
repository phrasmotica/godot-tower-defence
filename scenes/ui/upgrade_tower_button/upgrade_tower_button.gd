@tool
class_name UpgradeTowerButton extends Button

enum State { DISABLED, CANNOT_AFFORD, ENABLED, UPGRADING }

@export
var action_name: StringName

@export
var upgrade_index := 0

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

@export
var align_tooltip_bottom := false:
	set(value):
		align_tooltip_bottom = value

		_refresh()

var upgrade_level: TowerLevel

var _state_factory := UpgradeTowerButtonStateFactory.new()
var _current_state: UpgradeTowerButtonState = null

func _ready() -> void:
	switch_state(State.DISABLED)

func switch_state(state: State, state_data := UpgradeTowerButtonStateData.new()) -> void:
	if _current_state != null:
		_current_state.queue_free()

	_current_state = _state_factory.get_fresh_state(state)

	_current_state.setup(
		self,
		state_data)

	_current_state.state_transition_requested.connect(switch_state)
	_current_state.name = "UpgradeTowerButtonStateMachine: %s" % str(state)

	call_deferred("add_child", _current_state)

# TODO: move this into the base state
func set_upgrade_level(tower: Tower) -> void:
	upgrade_level = tower.get_upgrade(upgrade_index) if tower else null

	if upgrade_level:
		text = upgrade_level.level_name

		# prefer this to a tooltip so that we can control its appearance
		# by mouse enter/exit events rather than by the mouse being idle
		name_text.text = upgrade_level.level_name
		price_text.text = "Price: " + str(upgrade_level.price)
		description_text.text = upgrade_level.level_description

		enable_button()
	else:
		text = "-"
		description_text.text = "-"

		disable_button()

	_refresh()

	tooltip.hide()

func enable_button() -> void:
	switch_state(State.ENABLED)

func disable_button() -> void:
	switch_state(State.DISABLED)

func update_affordability(money: int) -> void:
	if _current_state != null:
		_current_state.update_affordability(money)

func _refresh() -> void:
	if align_tooltip_bottom:
		tooltip.position.y = self.size.y - tooltip.size.y
	else:
		tooltip.position.y = 0

func _on_mouse_entered():
	if upgrade_level:
		tooltip.show()

func _on_mouse_exited():
	tooltip.hide()

func _on_background_resized():
	# background node is a panel container, so shrinks to the
	# correct size after the tooltip content gets updated
	tooltip.size.y = tooltip.get_node("Background").size.y
	_refresh()
