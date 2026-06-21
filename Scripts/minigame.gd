class_name Minigame
extends Control

signal minigame_complete

@export var timer_time: float = 10.0

var timer: Timer = Timer.new()

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	timer.one_shot = true
	add_child(timer)
	timer.start(timer_time)

func finish_minigame(result: float):
	emit_signal("minigame_complete", result)
	# Result screen before removing nodes
	queue_free()

func _on_timer_timeout():
	finish_minigame(0.0)
