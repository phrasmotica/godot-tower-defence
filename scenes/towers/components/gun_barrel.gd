class_name GunBarrel extends Node2D

## Whether this barrel will emit its shoot signal, i.e. a projectile should be fired.
@export var enable_shoot := true

## Whether this barrel will emit its pulse signal, i.e. an effect should be created.
@export var enable_pulse := false

## Whether this barrel will emit its bolt signal, i.e. enemies along the firing line should be instantly affected.
@export var enable_bolt := false

@onready var shoot_timer = $ShootTimer
@onready var pulse_timer = $PulseTimer
@onready var bolt_timer = $BoltTimer

signal shoot
signal pulse
signal bolt

func setup(level: TowerLevel):
	if enable_shoot:
		start_shoot_timer(level)

	if enable_pulse:
		start_pulse_timer(level)

	if enable_bolt:
		start_bolt_timer(level)

func start_shoot_timer(level: TowerLevel):
	shoot_timer.wait_time = 1.0 / level.get_fire_rate()
	shoot_timer.start()

func start_pulse_timer(level: TowerLevel):
	pulse_timer.wait_time = 1.0 / level.get_effect_fire_rate()
	pulse_timer.start()

func start_bolt_timer(level: TowerLevel):
	bolt_timer.wait_time = 1.0 / level.get_fire_rate()
	bolt_timer.start()

# LOW: stop barrel if there are no enemies in range after the next timeout.
# Resume it once enemies come back in range, immediately firing it if enough
# time has passed since it was stopped
func pause():
	if enable_shoot:
		shoot_timer.stop()

	if enable_pulse:
		pulse_timer.stop()

	if enable_bolt:
		bolt_timer.stop()

func resume():
	if enable_shoot:
		shoot_timer.start()

	if enable_pulse:
		pulse_timer.start()

	if enable_bolt:
		bolt_timer.start()

func _on_shoot_timer_timeout():
	shoot.emit()

func _on_pulse_timer_timeout():
	pulse.emit()

func _on_bolt_timer_timeout():
	bolt.emit()
