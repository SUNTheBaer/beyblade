class_name RotateOverTime
extends Node3D

@export var axis: Vector3 = Vector3.UP
@export var rotation_speed: float = 0.25


func _process(dt: float) -> void:
	rotate(axis, rotation_speed * dt)
