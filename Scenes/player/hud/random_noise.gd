class_name RandomizeNoise
extends Node

@export var material: ShaderMaterial


func _process(dt: float) -> void:
	material.set_shader_parameter("color_strength", randf_range(0.25, 0.3))
