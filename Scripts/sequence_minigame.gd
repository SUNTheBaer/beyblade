extends Minigame

static var SFX: Array[AudioStream] = [
	load("res://Assets/sfx/mini game 3 key thock 1.mp3"),
	load("res://Assets/sfx/mini game 3 key thock 2.mp3"),
	load("res://Assets/sfx/mini game 3 key thock 3.mp3"),
	load("res://Assets/sfx/mini game 3 key thock 4.mp3"),
	load("res://Assets/sfx/mini game 3 key thock 5.mp3"),
	load("res://Assets/sfx/mini game 3 key thock 6.mp3"),
	load("res://Assets/sfx/mini game 3 key thock 7.mp3")
]

@onready var full_sequence: HBoxContainer = %FullSequence
@onready var timer_text: Label = %TimerText

@export var arrow_dict = {}

var sequence_elements: Array[Node]
var sequence_keys: Array[String] = []

const WRONG_COLOR: Color = Color(Color.FIREBRICK, 0.5)
const CORRECT_COLOR: Color = Color(Color.FOREST_GREEN, 0.5)

func _ready() -> void:
	super._ready()
	sequence_elements = full_sequence.get_children() as Array[Node]
	for element in sequence_elements:
		var random_arrow_key = arrow_dict.keys().pick_random() 
		sequence_keys.append(random_arrow_key)
		element.texture = arrow_dict[random_arrow_key]

func _process(__: float) -> void:
	if timer.paused:
		return
	
	timer_text.text = "%.2fs remain" % timer.time_left
	
	if Input.is_action_just_pressed("up"):
		_compare_input_to_sequence("up")
	elif Input.is_action_just_pressed("down"):
		_compare_input_to_sequence("down")
	elif Input.is_action_just_pressed("left"):
		_compare_input_to_sequence("left")
	elif Input.is_action_just_pressed("right"):
		_compare_input_to_sequence("right")

func _compare_input_to_sequence(input: String) -> void:
	AudioManager.play_sound(SFX.pick_random(), "minigame_sfx")
	var current_key = sequence_keys.pop_front()
	var current_element = sequence_elements.pop_front()
	if current_key == input:
		(current_element.get_child(0) as ColorRect).color = CORRECT_COLOR
		if sequence_keys.is_empty() and sequence_elements.is_empty():
			finish_minigame(1.0)
	else:
		(current_element.get_child(0) as ColorRect).color = WRONG_COLOR
		finish_minigame(0.0)
	
