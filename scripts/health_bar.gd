class_name HealthBar extends Control

@onready var health_bar_background = $HealthBarBackground
@onready var health_bar_fill = $HealthBarFill

@onready var bar_size = health_bar_background.size

var max_health = 0

func set_max_health(amount):
	max_health = amount
	draw_health(amount)

func draw_health(amount):
	var width = bar_size.x * float(amount) / max_health
	health_bar_fill.set_size(Vector2(width, bar_size.y))
