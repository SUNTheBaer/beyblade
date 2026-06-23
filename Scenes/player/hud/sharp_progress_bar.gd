@tool
class_name SharpProgressBar
extends Control

@export var progress: float = 0.5: set = _set_progress
@export var tip_length_ratio: float = 2.0
@export var color: Color = Color.WHITE


func _set_progress(value: float) -> void:
	progress = clampf(value, 0.0, 1.0)
	queue_redraw()


func _ready() -> void:
	resized.connect(queue_redraw)


func _draw() -> void:
	var tip := size.y * tip_length_ratio
	var sz := size - Vector2(tip, 0.0)
	var edge := sz.x * progress
	draw_rect(Rect2(Vector2(), Vector2(edge, sz.y)), color, true)
	draw_polygon([
		Vector2(edge, 0),
		Vector2(edge + tip, 0),
		Vector2(edge, sz.y)
	], [ color, color, color ])
