class_name PlayerMech
extends CharacterBody2D

@export var map: RandomizedCityscape
@export var monster: Monster
@export var max_angular_velocity: float = 4 * TAU
@export var angular_acceleration: float = PI / 32.0
@export var angular_velocity: float = PI / 16.0
@export var angular_position: float = 0.0
@export var linear_acceleration: float = 0.25
@export var linear_velocity: Vector2
@export var tilt_acceleration: float = 1.0
@export var tilt_direction: Vector2
@export var impact_register_distance: float = 480.0

@export_group("Internal")
@export var body: Node2D
@export var damaged: Node2D
@export var pointer: Node2D
@export var shadow: Node2D

var damaged_: float
var accum_: float
var predict_impact_: bool = false
var predict_impact_value_: float = 0.0
var predict_impact_time_scale_: float = 1.0
var predict_impact_zoom_scale_: float = 1.0
var shadow_height_: float = 24.0


func get_precession() -> float:
	if linear_velocity.length() < 1.0 or tilt_direction.length() < 1.0:
		return 0.0
	var n_component := linear_acceleration * 0.58
	var m_component := (1.0 - absf(linear_velocity.normalized().dot(tilt_direction.normalized()))) * (linear_velocity.length() + tilt_direction.length())
	var v_component := 1.0 - (n_component / (n_component + m_component))
	var result: float = sign(linear_velocity.angle_to(tilt_direction)) * PI * v_component
	
	print(n_component, " ", m_component, " ", v_component, " ", result)
	return result


func get_angular_acceleration() -> float:
	return angular_acceleration * linear_velocity.length() / linear_acceleration


func _ready() -> void:
	EntityManager.subscribe(self, 320.0)
	damaged.visible = false


func _process(dt: float) -> void:
	if damaged_ > 0.0 or Data.disabled:
		accum_ = fmod(accum_ + dt * (1.0 if Data.disabled else 4.0), 1.0)
		damaged_ = maxf(damaged_ - dt, 0.0)
		damaged.visible = (damaged_ > 0.0 or Data.disabled) and accum_ < 0.5
	
	if Data.disabled:
		shadow_height_ = maxf(0.0, shadow_height_ - dt * 24.0)
		pointer.visible = false
		var s := 1.05 + 0.15 * shadow_height_ / 24.0
		shadow.scale = Vector2(s, s)
	else:
		shadow.scale = Vector2(1.2, 1.2)
	
	shadow.global_position = global_position + Data.sun_direction * shadow_height_
	
	var pos := Vector2i(
		global_position.x / map.tile_set.tile_size.x,
		global_position.y / map.tile_set.tile_size.y)
	
	var out_of_bounds := pos.x <= -map.width / 2 \
		or pos.y <= -map.height / 2 \
		or pos.x > map.width / 2 \
		or pos.y > map.height / 2
	
	if Engine.time_scale >= 1.0:
		if Data.disabled:
			linear_velocity *= 0.9
		elif predict_impact_value_ > 0.0:
			linear_velocity *= 0.95
		elif out_of_bounds:
			linear_velocity *= 0.99
		else:
			if linear_velocity.length() > linear_acceleration:
				linear_velocity *= 0.999
				if linear_velocity.length() < linear_acceleration:
					linear_velocity = linear_velocity.normalized() * linear_acceleration
	
	if not Data.disabled:
		if Input.is_action_pressed("mecha_forward"):
			linear_velocity += linear_velocity.normalized() * dt * linear_acceleration
		if Input.is_action_pressed("mecha_brake"):
			linear_velocity = linear_velocity * 0.9
	linear_velocity = (linear_velocity + tilt_direction / TAU).normalized() * linear_velocity.length()
	
	if not Data.disabled:
		if Engine.time_scale >= 1.0:
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
	
	var impact := move_and_collide(impact_register_distance * linear_velocity.normalized(), true)
	if null == impact:
		Data.impact_sensor = 1.0
	
	if not predict_impact_:
		if predict_impact_value_ <= 0.0 \
			and monster.hp <= angular_velocity / (6.0 * TAU) \
			and null != impact:
			predict_impact_zoom_scale_ = 2.0
			predict_impact_ = true
		predict_impact_value_ = maxf(0.0, predict_impact_value_ - dt)
	else:
		if null == impact:
			predict_impact_zoom_scale_ = 1.0
			predict_impact_ = false
		else:
			Data.impact_sensor = 1.0 - impact.get_remainder().length() / impact_register_distance
	
	if not Data.victory:
		predict_impact_time_scale_ = pow(Data.impact_sensor, 2.0) * 0.9 + 0.1
	else:
		predict_impact_time_scale_ = 0.05
	
	velocity = lerp(velocity, linear_velocity, 0.05)
	var collision := move_and_collide(velocity * dt)
	if null != collision and collision.get_collider() is Monster and _is_heading_towards(collision.get_collider()):
		monster.impact_velocity = velocity * 0.5
		monster.hp = monster.hp - angular_velocity / (6.0 * TAU)
		angular_velocity = maxf(angular_velocity - velocity.length() / PI, 0.0)
		ImpactManager.create_impact(velocity.length(), 0.5)
		var n := collision.get_normal()
		print(n)
		print(velocity, " bounce ", velocity.bounce(n))
		velocity = 2.0 * velocity.bounce(n)
		linear_velocity = 2.0 * linear_velocity.bounce(n)
			
		damaged_ = 3.0
		
		predict_impact_zoom_scale_ = 1.0
		predict_impact_ = false
		predict_impact_value_ = 1.0
	
	if predict_impact_time_scale_ != Engine.time_scale:
		var s: float = sign(predict_impact_time_scale_ - Engine.time_scale)
		Engine.time_scale += dt * s
		if sign(predict_impact_time_scale_ - Engine.time_scale) != s:
			Engine.time_scale = predict_impact_time_scale_
	
	if predict_impact_zoom_scale_ != Data.zoom_scale:
		var s: float = sign(predict_impact_zoom_scale_ - Data.zoom_scale)
		Data.zoom_scale += dt * s
		if sign(predict_impact_zoom_scale_ - Data.zoom_scale) != s:
			Data.zoom_scale = predict_impact_zoom_scale_


func _is_heading_towards(object: Node2D) -> bool:
	return (object.global_position - global_position).normalized().dot(velocity.normalized()) > 0.0
