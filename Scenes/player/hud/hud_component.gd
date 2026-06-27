class_name HUDComponent
extends Control

signal capacity_exceeded
signal within_parameters

@export var alert_display_text: String = "ALERT"
@export var is_capacity_exceeded: bool = false: set = _set_is_capacity_exceeded
@export var alert_audio: AudioStream

var alert: int = 0


func _set_is_capacity_exceeded(value: bool) -> void:
	if value == is_capacity_exceeded:
		return
	is_capacity_exceeded = value
	if is_capacity_exceeded:
		capacity_exceeded.emit()
		alert = AudioManager.play_persistent_sound(alert_audio, "alarm_sfx")
	else:
		within_parameters.emit()
		AudioManager.stop_persistent_sound(alert)
