class_name StartTimeScaleController
extends Node

@export var time_to_scale: float = 1.5


func _ready() -> void:
	Data.time_scale = 0.0
	get_tree().create_tween().tween_property(Data, "time_scale", 1.0, time_to_scale)
