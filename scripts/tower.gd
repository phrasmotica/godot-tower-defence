extends Node2D

@onready var range_node = $Range
@onready var selection_node = $Selection

var is_selected = false

func _ready():
	range_node.hide()

func _on_collision_area_mouse_entered():
	range_node.show()

func _on_collision_area_mouse_exited():
	if not is_selected:
		range_node.hide()

func _on_collision_area_input_event(viewport:Node, event:InputEvent, shape_idx:int):
	if event.is_pressed():
		selection_node.show()
		is_selected = true
