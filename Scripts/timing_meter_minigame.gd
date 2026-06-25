extends Minigame

@onready var timing_meter: ColorRect = %TimingMeter
@onready var select_bar: ColorRect = %SelectBar
@onready var target_bar: ColorRect = %TargetBar
@onready var timer_text: Label = %TimerText

@export var select_bar_velocity: float = 0.05
@export var select_bar_offset: int = 10
@export var win_threshold: int = 3

var select_bar_direction: int = 1
var win_count: int = 0

func _ready() -> void:
	super._ready()
	target_bar.position.x = randf_range(0, timing_meter.size.x - target_bar.size.x)

func _physics_process(dt: float) -> void:
	if timer.paused:
		return
	
	timer_text.text = "%.2fs remains" % timer.time_left
	select_bar.position.x += select_bar_velocity * select_bar_direction * dt
	
	if (select_bar.position.x > timing_meter.size.x - select_bar_offset) or (select_bar.position.x < select_bar_offset):
		select_bar_direction *= -1
	
	if Input.is_action_just_pressed("accept"):
		if select_bar.position.x > target_bar.position.x - select_bar_offset and select_bar.position.x < target_bar.position.x + target_bar.size.x + select_bar_offset:
			_update_score()
			target_bar.position.x = randf_range(0, timing_meter.size.x)
		else:
			_failed_minigame()

func _update_score() -> void:
	win_count += 1
	if win_count >= win_threshold:
		finish_minigame(1.0)

func _failed_minigame() -> void:
	finish_minigame(0.0)
