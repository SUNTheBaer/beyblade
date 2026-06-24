extends Node

@export var victory: bool = false
@export var disabled: bool = false
@export var sun_direction: Vector2 = Vector2(1, 1).normalized()
@export var zoom_scale: float = 1.0
@export var impact_sensor: float = 1.0


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mecha_launch"):
		disabled = true
	if Input.is_action_just_pressed("auto_win"):
		victory = true
