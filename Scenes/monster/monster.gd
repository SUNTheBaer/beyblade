class_name Monster
extends StaticBody2D

@export var hp: float = 1.0: set = _set_hp
@export var player: PlayerMech
@export var body: AnimatedSprite2D
@export var shadow: AnimatedSprite2D
@export var target_velocity: Vector2
@export var impact_velocity: Vector2
@export var rotation_speed: float = PI / 4.0


func _set_hp(value: float) -> void:
	hp = clampf(value, 0.0, 1.0)
	if hp <= 0.0:
		Data.victory = true


func _ready() -> void:
	EntityManager.subscribe(self, 480.0)
	body.play()


func _process(dt: float) -> void:
	dt *= Data.time_scale
	body.speed_scale = Data.time_scale
	shadow.speed_scale = Data.time_scale
	
	if not is_zero_approx(impact_velocity.length()):
		global_position += impact_velocity * dt
		impact_velocity *= 0.9
		body.animation = "default"
	else:
		var target_rotation := (player.global_position - global_position).angle()
		var diff := angle_difference(target_rotation, rotation)
		print("diff ", diff)
		rotation = target_rotation \
			if absf(diff) < rotation_speed * dt \
			else rotation - rotation_speed * dt * sign(diff)
		target_velocity = Vector2.from_angle(rotation) * 128.0
		if not is_zero_approx(target_velocity.length()):
			body.animation = "walk"
			global_position += target_velocity * dt
		else:
			body.animation = "default"
	
	shadow.animation = body.animation
	shadow.frame = body.frame
	shadow.global_position = global_position + Data.sun_direction * 32.0
