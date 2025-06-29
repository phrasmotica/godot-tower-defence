class_name RicochetTracker

var _max_count := 0
var _current_count := 0

func _init(max_count: int) -> void:
	_max_count = max_count
	_current_count = max_count

func try_deduct() -> bool:
	if _current_count <= 0:
		return false

	_current_count -= 1
	return true

func count() -> int:
	return _current_count
