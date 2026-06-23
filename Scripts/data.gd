extends Node

@export var disabled: bool = false
@export var sun_direction: Vector2 = Vector2(1, 1).normalized()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mecha_launch"):
		disabled = true
