class_name TowerHighlighter

func highlight(tower: Tower, base_z_index: int) -> void:
	tower.z_index = base_z_index + 1

func unhighlight(tower: Tower) -> void:
	tower.z_index = 0
