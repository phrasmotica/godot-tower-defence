class_name Tower extends Node2D

@onready var path: Path = %PathWaypoints

@onready var range_node = $Range
@onready var selection_node = $Selection
@onready var levels_node = $Levels

var is_selected = false

signal on_selected
signal on_deselected

func _ready():
	levels_node.path = path

	deselect()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		deselect()

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

func _on_collision_area_mouse_entered():
	range_node.show()

func _on_collision_area_mouse_exited():
	if not is_selected:
		range_node.hide()

func _on_collision_area_input_event(viewport:Node, event:InputEvent, shape_idx:int):
	if event.is_pressed():
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
