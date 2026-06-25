class_name HUDMaxAngularVelocity
extends HUDComponent

@export var player: PlayerMech

var accum_: float


func _process(dt: float) -> void:
	is_capacity_exceeded = player.is_at_max_angular_velocity()
	if is_capacity_exceeded:
		accum_ += dt * Data.time_scale
		if accum_ > 8.0:
			Data.disabled = true
	else:
		accum_ = 0.0
