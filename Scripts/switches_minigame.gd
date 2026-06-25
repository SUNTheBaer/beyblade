extends Minigame

@onready var timer_text: Label = %TimerText

@export var switches: Array[Switch]

func _physics_process(__: float) -> void:
	if timer.paused:
		return
	
	timer_text.text = "%.2fs remain" % timer.time_left

func _on_switch_set_switch_position() -> void:
	for switch in switches:
		if not switch.correct_position_bool:
			return
	finish_minigame(1.0)
