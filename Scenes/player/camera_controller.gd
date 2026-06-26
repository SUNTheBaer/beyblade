class_name CameraController
extends Node2D

@export var snappiness: float = 0.1
@export var player: PlayerMech
@export var monster: Monster
@export var camera: Camera2D

var base_zoom_: Vector2
var velocity_exceeded_level_: float


func _ready() -> void:
	base_zoom_ = camera.zoom


func _process(dt: float) -> void:
	dt *= Data.pause_scale
	
	var follow: Vector2
	if player.imminent_impact():
		follow = (monster.global_position + player.global_position) / 2.0
	else:
		follow = player.global_position
	global_position = lerp(global_position, follow, snappiness)
	
	if player.is_at_max_angular_velocity():
		velocity_exceeded_level_ += dt
	else:
		velocity_exceeded_level_ = 0.0
	
	var x := minf(0.5 / dt, pow(ImpactManager.impact, 3.0) / 16.0) + PI * velocity_exceeded_level_ / 2.0
	var next := camera.position + Vector2(
		clamp(randfn(0.0, x * 192.0), -3600.0, 3600.0),
		clamp(randfn(0.0, x * 192.0), -3600.0, 3600.0)) * dt
	camera.position = next * 0.25
	
	camera.zoom = base_zoom_ * Data.zoom_scale
