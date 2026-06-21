extends Minigame

@onready var timer_text: Label = %TimerText

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()

func _physics_process(delta: float) -> void:
	timer_text.text = "%.2f" % timer.time_left
