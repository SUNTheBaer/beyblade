@tool
class_name HUDPrecession
extends Control

@export var player: PlayerMecha

@export_group("Internal")
@export var player_icon: TextureRect


func _process(delta: float) -> void:
	player_icon.rotation = -player.precession / PI
	queue_redraw()


func _draw() -> void:
	print(size)
	draw_line(Vector2(0, size.y), Vector2(size.x, size.y), Color.WHITE, 3.0)
	draw_line(Vector2(size.x / 2.0, 0.0), Vector2(size.x / 2.0, size.y), Color.WHITE, 3.0)
