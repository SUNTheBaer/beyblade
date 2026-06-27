extends Node

@export var victory: bool = false: set = _set_victory
@export var disabled: bool = false: set = _set_disabled
@export var sun_direction: Vector2 = Vector2(1, 1).normalized()
@export var time_scale: float = 1.0
@export var pause_scale: float = 1.0
@export var zoom_scale: float = 1.0
@export var impact_sensor: float = 1.0


func _set_victory(value: bool) -> void:
	victory = value
	if victory:
		AudioManager.stop_all_sounds()
		AudioManager.switch_music(null, 1.0)


func _set_disabled(value: bool) -> void:
	disabled = value
	if disabled:
		AudioManager.stop_all_sounds()
		AudioManager.switch_music(null, 1.0)


func get_time() -> float:
	return time_scale * pause_scale


func reset() -> void:
	victory = false
	disabled = false
	sun_direction = Vector2(1, 1).normalized()
	time_scale = 1.0
	pause_scale = 1.0
	zoom_scale = 1.0
	impact_sensor = 1.0


func _process(dt: float) -> void:
	dt *= pause_scale
	
	# print(pause_scale)
	sun_direction = sun_direction.rotated(TAU / 60.0 * dt)
	# if Input.is_action_just_pressed("mecha_launch"):
	# 	disabled = true
	if Input.is_action_just_pressed("auto_win"):
		victory = true
	pass
