class_name HUDDebugElement
extends HUDComponent


func _process(__: float) -> void:
	if Input.is_action_just_pressed("mecha_debug"):
		is_capacity_exceeded = true
