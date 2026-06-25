class_name HUDMinAngularVelocity
extends HUDComponent

@export var player: PlayerMech
@export var capacity: float = 3.0

var accum_: float

func _process(dt: float) -> void:
	dt *= Data.get_time()
	
	is_capacity_exceeded = player.angular_velocity < player.get_angular_acceleration() * capacity
	if is_capacity_exceeded:
		accum_ += dt
		if accum_ > capacity + 1.0:
			Data.disabled = true
			AudioManager.switch_music(null, 3.0)
	else:
		accum_ = 0.0
