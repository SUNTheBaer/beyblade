class_name HUDMaxAngularVelocity
extends HUDComponent

@export var player: PlayerMech

var accum_: float


func _process(dt: float) -> void:
	dt *= Data.get_time()
	
	is_capacity_exceeded = player.is_at_max_angular_velocity()
	if is_capacity_exceeded:
		accum_ += dt
		if accum_ > 8.0:
			Data.disabled = true
	else:
		accum_ = 0.0
