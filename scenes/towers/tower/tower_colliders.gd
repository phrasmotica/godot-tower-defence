class_name TowerColliders
extends Node2D

@onready
var collision_area: Area2D = %CollisionArea

signal path_area_entered
signal path_area_exited

func _ready() -> void:
	collision_area.body_entered.connect(_on_collision_area_body_entered)
	collision_area.body_exited.connect(_on_collision_area_body_exited)

# NOTE: Area2D handling a collision with a TileSet's physics layer
# must use body_entered/exited rather than area_entered/exited!!
func _on_collision_area_body_entered(_body: Node2D) -> void:
	path_area_entered.emit()

func _on_collision_area_body_exited(_body: Node2D) -> void:
	path_area_exited.emit()
