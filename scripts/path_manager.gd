class_name PathManager extends Node2D

@export
var paths: Array[Path] = []

func _ready():
	for i in range(paths.size()):
		paths[i].visible = i == 0
