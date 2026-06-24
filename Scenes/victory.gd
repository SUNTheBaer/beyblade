class_name VictoryController
extends Control

@export var label: Control


func _ready() -> void:
	label.self_modulate.a = 0.0

func _process(dt: float) -> void:
	label.self_modulate.a = minf(1.0, label.self_modulate.a + dt * 0.25)
