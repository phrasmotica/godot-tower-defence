extends PathFollow2D

@export_range(0.1, 0.2)
var movement_speed: float

func _process(delta):
	move(delta)

func move(delta):
	progress_ratio += movement_speed * delta
