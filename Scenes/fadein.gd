class_name FadeInController
extends Control

@export var initial_wait_time: float = 0.0
@export var initial_fade: float = 0.0
@export var fade_in_time: float = 4.0

var accum_: float = 0.0


func _ready() -> void:
	visible = true
	modulate.a = initial_fade


func _process(dt: float) -> void:
	dt *= Data.pause_scale
	
	if accum_ < initial_wait_time:
		accum_ += dt
		return
	
	modulate.a = clampf(modulate.a + dt / fade_in_time, 0.0, 1.0)
	if 0.0 >= modulate.a:
		queue_free()
