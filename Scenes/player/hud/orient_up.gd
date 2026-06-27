class_name UtilOrientUp
extends Control


func _process(delta: float) -> void:
	rotation = -(get_parent().get_parent() as Node2D).global_rotation
