class_name CameraController
extends Node2D

@export var snappiness: float = 0.05
@export var follow_node: Node2D
@export var alt_follow_node: Node2D
@export var camera: Camera2D

var base_zoom_: Vector2


func _ready() -> void:
	base_zoom_ = camera.zoom


func _process(dt: float) -> void:
	var follow: Vector2
	if Engine.time_scale < 1.0:
		follow = (alt_follow_node.global_position + follow_node.global_position) / 2.0
	else:
		follow = follow_node.global_position
	global_position = lerp(global_position, follow, snappiness)
	
	var x := minf(0.5 / dt, pow(ImpactManager.impact, 3.0) / 16.0)
	var next := camera.position + Vector2(
		clamp(randfn(0.0, x * 32.0), -128.0, 128.0),
		clamp(randfn(0.0, x * 32.0), -128.0, 128.0)) * dt
	camera.position = next * 0.7
	camera.zoom = base_zoom_ * Data.zoom_scale
