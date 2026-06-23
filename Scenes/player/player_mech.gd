class_name PlayerMech
extends CharacterBody2D

@export var map: RandomizedCityscape
@export var angular_acceleration: float = PI / 32.0
@export var angular_velocity: float = PI / 16.0
@export var angular_position: float = 0.0
@export var linear_acceleration: float = 0.25
@export var linear_velocity: Vector2
@export var tilt_acceleration: float = 1.0
@export var tilt_direction: Vector2

@export_group("Internal")
@export var body: Node2D
@export var pointer: Node2D


func _ready() -> void:
	EntityManager.subscribe(self, 320.0)


func _process(dt: float) -> void:
	var pos := Vector2i(
		global_position.x / map.tile_set.tile_size.x,
		global_position.y / map.tile_set.tile_size.y)
	
	var out_of_bounds := pos.x <= -map.width / 2 \
		or pos.y <= -map.height / 2 \
		or pos.x > map.width / 2 \
		or pos.y > map.height / 2
	
	if out_of_bounds:
		linear_velocity *= 0.99
	else:
		if linear_velocity.length() > 1.0:
			linear_velocity *= 0.999
			if linear_velocity.length() < 1.0:
				linear_velocity = linear_velocity.normalized()
	
	if Input.is_action_pressed("mecha_forward"):
		linear_velocity += linear_velocity.normalized() * dt * linear_acceleration
	linear_velocity = (linear_velocity + tilt_direction / TAU).normalized() * linear_velocity.length()
	
	tilt_direction *= 0.999
	if Input.is_action_pressed("mecha_tilt_left"):
		tilt_direction += linear_velocity.rotated(-PI/2).normalized() * dt * tilt_acceleration
	if Input.is_action_pressed("mecha_tilt_right"):
		tilt_direction += linear_velocity.rotated(PI/2).normalized() * dt * tilt_acceleration
		
	pointer.rotation = (tilt_direction + linear_velocity / TAU).normalized().angle()
	
	if out_of_bounds:
		angular_velocity = maxf(0.0, angular_velocity - 0.5 * angular_acceleration * dt)
	else:
		angular_velocity = maxf(0.0, angular_velocity + angular_acceleration * dt)
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
