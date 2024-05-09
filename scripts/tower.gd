class_name Tower extends Node2D

enum TowerMode { PLACING, FIRING }

@onready var path: Path = %PathWaypoints

@onready var range_node = $Range
@onready var selection_node = $Selection
@onready var levels_node = $Levels

var tower_mode = TowerMode.PLACING
var is_selected = false

signal on_placed(tower: Tower)
signal on_selected
signal on_deselected

func _ready():
	deselect()

func _process(delta):
	if tower_mode == TowerMode.PLACING:
		position = get_viewport().get_mouse_position()

	if tower_mode == TowerMode.FIRING:
		if Input.is_action_just_pressed("ui_cancel"):
			deselect()

		if Input.is_action_just_pressed("ui_text_delete"):
			sell()

		levels_node.scan(delta)

func is_placing():
	return tower_mode == TowerMode.PLACING

func set_placing():
	tower_mode = TowerMode.PLACING

func set_firing():
	# TODO: self.path is null here. We need a better way of passing it down,
	# or perhaps this isn't the approach we should take at all...
	levels_node.path = self.path
	tower_mode = TowerMode.FIRING

func select():
	selection_node.show()
	range_node.show()
	is_selected = true

	on_selected.emit()

func deselect():
	selection_node.hide()
	range_node.hide()
	is_selected = false

	on_deselected.emit()

func sell():
	queue_free()

func _on_collision_area_mouse_entered():
	range_node.show()

func _on_collision_area_mouse_exited():
	if not is_selected:
		range_node.hide()

func _on_collision_area_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	if event.is_pressed():
		if tower_mode == TowerMode.PLACING:
			set_firing()
			on_placed.emit(self)

		if tower_mode == TowerMode.FIRING:
			select()

func _on_barrel_shoot():
	if not levels_node.should_shoot():
		return

	var level = levels_node.get_current_level()
	print("Current level is " + level.name)

	var projectile = level.stats.projectile

	var bullet: Projectile = projectile.instantiate()
	bullet.damage = level.stats.damage
	bullet.direction = Vector2.RIGHT.rotated(levels_node.rotation)

	print("Projectile now has damage " + str(bullet.damage))

	add_child(bullet)
