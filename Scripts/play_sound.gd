class_name UtilPlaySound
extends Node

@export var sound: AudioStream


func _ready() -> void:
	_play_sound.call_deferred()


func _play_sound() -> void:
	print("Play sound")
	AudioManager.play_sound(sound)
