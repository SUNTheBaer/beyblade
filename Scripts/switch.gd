class_name Switch
extends TextureRect

signal set_switch_position

@onready var result_light: TextureRect = $"../ResultLight"
@onready var up_button: Button = $"UpButton"
@onready var down_button: Button = $"DownButton"

@export var possible_positions = {}
@export var possible_results = {}
var starting_position_key: String
var correct_position_key: String
var correct_position_bool: bool
var current_position: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	starting_position_key = possible_positions.keys().pick_random()
	correct_position_key = possible_positions.keys().pick_random()
	_set_switch_position(starting_position_key)

func _on_up_button_pressed() -> void:
	match current_position:
		"down":
			_set_switch_position("neutral")
		"neutral":
			_set_switch_position("up")

func _on_down_button_pressed() -> void:
	match current_position:
		"up":
			_set_switch_position("neutral")
		"neutral":
			_set_switch_position("down")

func _set_switch_position(position: String) -> void:
	current_position = position
	texture = possible_positions[position]
	if current_position == correct_position_key:
		result_light.texture = possible_results["green"]
		correct_position_bool = true
	else:
		result_light.texture = possible_results["red"]
		correct_position_bool = false
	match position:
		"up":
			up_button.disabled = true
		"neutral":
			up_button.disabled = false
			down_button.disabled = false
		"down":
			down_button.disabled = true
	emit_signal("set_switch_position")
