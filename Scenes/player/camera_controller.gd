class_name CameraController
extends Node2D

@export var snappiness: float = 0.05
@export var follow_node: Node2D
@export var camera: Camera2D
@export var zoom_value: float = 1.0

var base_zoom_: Vector2


func _ready() -> void:
	base_zoom_ = camera.zoom


func _process(dt: float) -> void:
	global_position = lerp(global_position, follow_node.global_position, snappiness)
	
	var x := minf(0.5 / dt, pow(ImpactManager.impact, 3.0) / 16.0)
	var next := camera.position + Vector2(randfn(0.0, x * 128.0), randfn(0.0, x * 128.0)) * dt
	camera.position = next * 0.7
	
	var ratio := randfn(0.0, x / 32.0) * dt
	var nzoom: Vector2 = clamp(camera.zoom + Vector2(ratio, ratio), Vector2(0.1, 0.1), Vector2(2.0, 2.0))
	var base := base_zoom_ * zoom_value
	camera.zoom = (nzoom - base) * 0.9 + base
