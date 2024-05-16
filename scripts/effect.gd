class_name Effect extends Node

## The length of time that the effect lasts for, in seconds.
@export_range(1.0, 3.0)
var duration := 1.0

var enemy: Enemy

func set_timer():
    var timer = get_tree().create_timer(duration)

    timer.timeout.connect(act_end)
    timer.timeout.connect(queue_free)

func act_start():
    # implemented in child classes
    pass

func act_end():
    # implemented in child classes
    pass
