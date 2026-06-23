class_name HUDNavigation
extends Control

@export var mech: PlayerMecha
@export var width: float = 2048.0


func _ready() -> void:
	queue_redraw()


func _draw() -> void:
	draw_line(Vector2(0.0, 0.0), Vector2(width, 0.0), Color.WHITE, 8.0)
	var spacing := width / 36.0
	for i in 37:
		var x := spacing * i
		if i % 9 == 0:
			draw_line(Vector2(x, 0.0), Vector2(x, 48.0), Color.WHITE, 2.0)
		elif i % 6 == 0:
			draw_line(Vector2(x, 0.0), Vector2(x, 24.0), Color.WHITE, 2.0)
		elif i % 3 == 0:
			draw_line(Vector2(x, 0.0), Vector2(x, 20.0), Color.WHITE, 2.0)
		else:
			draw_line(Vector2(x, 0.0), Vector2(x, 16.0), Color.WHITE, 2.0)
