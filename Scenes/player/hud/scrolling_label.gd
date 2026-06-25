class_name ScrollingLabel
extends Control

@export var base_text: String
@export var label: Label
@export var scrolling_speed: float = 32.0

var base_size_: float
var scrolling_amount_: float


func _ready() -> void:
	var base_font := label.get_theme_font("font")
	var base_font_size := label.get_theme_font_size("font_size")
	base_size_ = base_font.get_string_size(base_text, HORIZONTAL_ALIGNMENT_LEFT, -1, base_font_size).x
	
	size = get_parent_control().size
	
	get_viewport().size_changed.connect(_sync_size)
	_sync_size()


func _process(dt: float) -> void:
	dt *= Data.pause_scale
	scrolling_amount_ = fmod(scrolling_amount_ + dt * scrolling_speed, base_size_)
	label.position.x = -scrolling_amount_


func _sync_size() -> void:
	_deferred_sync_size.call_deferred()


func _deferred_sync_size() -> void:
	var accum: String = ""
	for i in ceili(size.x / base_size_) + 1:
		accum += base_text
	label.text = accum
