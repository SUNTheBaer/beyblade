class_name FadeInController
extends Control

@export var initial_fade: float = 0.0
@export var fade_in_time: float = 4.0


func _ready() -> void:
	modulate.a = initial_fade

func _process(dt: float) -> void:
	modulate.a = clampf(modulate.a + dt / fade_in_time, 0.0, 1.0)
	if 0.0 >= modulate.a:
		queue_free()
