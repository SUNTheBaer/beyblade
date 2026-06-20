class_name PlayerMecha
extends CharacterBody3D

static var GRAVITY: Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity") \
	* ProjectSettings.get_setting("physics/3d/default_gravity_vector")

@export var angular_acceleration := PI / 32
@export var angular_velocity := 0.0
@export var angular_position := 0.0

@export var linear_acceleration := 3.0

@export var up_vector := Vector3.UP

@export var axis_acceleration: float = 0.025
@export var axis_momentum: float = 0.0
@export var axis_angle: float

@export var downward_velocity: Vector3

@export_group("Internal")
@export var visuals: Node3D


func _physics_process(dt: float) -> void:
	velocity *= 0.99
	if Input.is_action_pressed("mecha_forward"):
		velocity += Vector3.FORWARD.rotated(Vector3.UP, axis_angle) * dt * linear_acceleration
	
	downward_velocity += GRAVITY * dt
	angular_velocity += angular_acceleration / (1.0 + angular_velocity) * dt
	angular_position += angular_velocity * dt
	
	axis_momentum *= 0.99
	if Input.is_action_pressed("mecha_tilt_left"):
		axis_momentum = minf(axis_momentum + velocity.length() * dt * axis_acceleration, PI / 2)
	if Input.is_action_pressed("mecha_tilt_right"):
		axis_momentum = maxf(axis_momentum - velocity.length() * dt * axis_acceleration, -PI / 2)
	
	axis_angle += axis_momentum * dt
	
	print(-axis_momentum / TAU)
	global_transform = Transform3D.IDENTITY \
		.looking_at(velocity, Vector3.UP) \
		.rotated_local(Vector3.FORWARD, -axis_momentum / TAU) \
		.translated(global_position)
	
	visuals.transform = Transform3D.IDENTITY.rotated(Vector3.UP, angular_position)
	
	move_and_slide()

	"""
	var collision := move_and_collide(downward_velocity, true)
	if null == collision:
		global_position += downward_velocity
		return
	
	print(collision.get_remainder().y)
	
	global_position += downward_velocity * collision.get_remainder()
	for i in collision.get_collision_count():
		if collision.get_normal() != Vector3(0, 1, 0):
			continue
		downward_velocity = -downward_velocity * 0.5
	"""
