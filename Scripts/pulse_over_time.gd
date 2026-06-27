class_name PulseOverTime
extends Control

var accum_: float = 0.0


func _process(dt: float) -> void:
	accum_ = fmod(accum_ + dt, 1.0)
	self_modulate.a = (cos(4.0 * TAU * accum_) + 1.0) / 2.0 * 0.75 + 0.25
