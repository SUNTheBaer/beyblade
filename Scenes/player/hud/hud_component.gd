class_name HUDComponent
extends Control

signal capacity_exceeded
signal within_parameters

@export var alert_display_text: String = "ALERT"
@export var is_capacity_exceeded: bool = false: set = _set_is_capacity_exceeded


func _set_is_capacity_exceeded(value: bool) -> void:
	if value == is_capacity_exceeded:
		return
	is_capacity_exceeded = value
	if is_capacity_exceeded:
		capacity_exceeded.emit()
	else:
		within_parameters.emit()
