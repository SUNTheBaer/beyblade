extends Node
class_name Minigame

signal minigame_complete

func finish_minigame(result: float):
	emit_signal("minigame_complete", result)
