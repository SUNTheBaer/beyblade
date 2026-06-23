class_name HUD
extends Control

@export var player: PlayerMech

@export_group("Internal")
@export var progress: SharpProgressBar
@export var potential_progress: SharpProgressBar

var floating_progress_: float

func _process(dt: float) -> void:
	progress.progress = player.angular_velocity / player.max_angular_velocity
	floating_progress_ = lerp(floating_progress_, progress.progress, 0.05)
	potential_progress.progress = floating_progress_ + player.get_angular_acceleration() / player.max_angular_velocity
	
