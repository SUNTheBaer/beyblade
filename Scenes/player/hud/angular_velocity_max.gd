class_name HUDMaxAngularVelocity
extends HUDComponent

@export var player: PlayerMech
@export var slow_down: HUDSlowDown

var accum_: float


func _process(dt: float) -> void:
	dt *= Data.get_time()
	
	is_capacity_exceeded = player.is_at_max_angular_velocity()
	if is_capacity_exceeded:
		slow_down.register(self, true)
		accum_ += dt
		if accum_ > 8.0:
			Data.disabled = true
			AudioManager.switch_music(null, 3.0)
	else:
		slow_down.register(self, false)
		accum_ = 0.0
