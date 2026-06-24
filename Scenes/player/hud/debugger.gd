class_name HUDDebugElement
extends HUDComponent


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mecha_launch"):
		is_capacity_exceeded = true
