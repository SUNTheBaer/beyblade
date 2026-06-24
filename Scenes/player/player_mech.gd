class_name PlayerMech
extends CharacterBody2D

@export var map: RandomizedCityscape
@export var max_angular_velocity: float = 4 * TAU
@export var angular_acceleration: float = PI / 32.0
@export var angular_velocity: float = PI / 16.0
@export var angular_position: float = 0.0
@export var linear_acceleration: float = 0.25
@export var linear_velocity: Vector2
@export var tilt_acceleration: float = 1.0
@export var tilt_direction: Vector2
@export var time_scale_modifier: float = 0.25

@export_group("Internal")
@export var body: Node2D
@export var damaged: Node2D
@export var pointer: Node2D
@export var shadow: Node2D

var damaged_: float
var accum_: float

var linear_input_disabled: bool = false
var tilt_input_disabled: bool = false

func get_precession() -> float:
	if linear_velocity.length() < 1.0 or tilt_direction.length() < 1.0:
		return 0.0
	var n_component := linear_acceleration * 0.58
	var m_component := (1.0 - absf(linear_velocity.normalized().dot(tilt_direction.normalized()))) * (linear_velocity.length() + tilt_direction.length())
	var v_component := 1.0 - (n_component / (n_component + m_component))
	var result: float = sign(linear_velocity.angle_to(tilt_direction)) * PI * v_component
	return result


func get_angular_acceleration() -> float:
	return angular_acceleration * linear_velocity.length() / linear_acceleration


func _ready() -> void:
	EntityManager.subscribe(self, 320.0)
	damaged.visible = false


func _process(dt: float) -> void:
	if Data.disabled:
		pointer.visible = false
	
	if damaged_ > 0.0:
		accum_ = fmod(accum_ + dt * 4.0, 1.0)
		damaged_ = maxf(damaged_ - dt, 0.0)
		damaged.visible = damaged_ > 0.0 and accum_ < 0.5
	
	shadow.global_position = global_position + Data.sun_direction * 24.0
	
	var pos := Vector2i(
		global_position.x / map.tile_set.tile_size.x,
		global_position.y / map.tile_set.tile_size.y)
	
	var out_of_bounds := pos.x <= -map.width / 2 \
		or pos.y <= -map.height / 2 \
		or pos.x > map.width / 2 \
		or pos.y > map.height / 2
	
	if Data.disabled:
		linear_velocity *= 0.9
	elif out_of_bounds:
		linear_velocity *= 0.99
	else:
		if linear_velocity.length() > 1.0:
			linear_velocity *= 0.999
			if linear_velocity.length() < 1.0:
				linear_velocity = linear_velocity.normalized()
	
	if not Data.disabled and not linear_input_disabled:
		if Input.is_action_pressed("mecha_forward"):
			linear_velocity += linear_velocity.normalized() * dt * linear_acceleration
		if Input.is_action_pressed("mecha_brake"):
			linear_velocity = linear_velocity * 0.9
	linear_velocity = (linear_velocity + tilt_direction / TAU).normalized() * linear_velocity.length()
	
	if not Data.disabled and not tilt_input_disabled:
		tilt_direction *= 0.999
		if Input.is_action_pressed("mecha_tilt_left"):
			tilt_direction += linear_velocity.rotated(-PI/2).normalized() * dt * tilt_acceleration
		if Input.is_action_pressed("mecha_tilt_right"):
			tilt_direction += linear_velocity.rotated(PI/2).normalized() * dt * tilt_acceleration
		
	pointer.rotation = (tilt_direction + linear_velocity / TAU).normalized().angle()
	
	if Data.disabled:
		angular_velocity = clampf(angular_velocity - TAU * dt, 0, max_angular_velocity)
	elif out_of_bounds:
		angular_velocity = clampf(angular_velocity - 0.5 * get_angular_acceleration() * dt, 0, max_angular_velocity)
	else:
		angular_velocity = clampf(angular_velocity + get_angular_acceleration() * dt, 0, max_angular_velocity)
	angular_position += angular_velocity * dt
	
	body.rotation = angular_position
	
	velocity = lerp(velocity, linear_velocity, 0.05)
	var collision := move_and_collide(velocity * dt)
	if null != collision and collision.get_collider() is Monster:
		angular_velocity = maxf(angular_velocity - velocity.length() / PI, 0.0)
		ImpactManager.create_impact(velocity.length(), 0.5)
		var n := collision.get_normal()
		velocity = velocity.bounce(n)
		linear_velocity = linear_velocity.bounce(n)
		damaged_ = 3.0


func _on_ability_clicked() -> void:
	linear_input_disabled = true
	tilt_input_disabled = true
	Engine.time_scale = time_scale_modifier


func _on_direction_minigame_complete(result: float) -> void:
	linear_input_disabled = false
	tilt_input_disabled = false
	Engine.time_scale = 1.0
	if result > 0.0:
		# Dash forward
		linear_velocity *= 3
		await get_tree().create_timer(0.2).timeout
		linear_velocity /= 3


func _on_stun_minigame_complete(result: float) -> void:
	linear_input_disabled = false
	tilt_input_disabled = false
	Engine.time_scale = 1.0
	if result > 0.0:
		# Greatly reduce impact of collisions
		pass

func _on_velocity_minigame_complete(result: float) -> void:
	linear_input_disabled = false
	Engine.time_scale = 1.0
	if result > 0.0:
		# Increase accel but can't turn
		linear_acceleration = 1.0
		await get_tree().create_timer(2.0).timeout
		tilt_input_disabled = false
		linear_acceleration = 0.25
