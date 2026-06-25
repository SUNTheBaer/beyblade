class_name FadeInController
extends Control

@export var fade_in_time: float = 4.0
@export var label: Control


func _ready() -> void:
	label.self_modulate.a = 0.0

func _process(dt: float) -> void:
	label.self_modulate.a = minf(1.0, label.self_modulate.a + dt / fade_in_time)
