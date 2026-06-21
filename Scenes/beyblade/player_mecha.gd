class_name PlayerMecha
extends CharacterBody3D

static var GRAVITY: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export_group("Axis Rotation")
@export var angular_acceleration := PI / 32
@export var angular_velocity := TAU
@export var angular_position := 0.0

@export var launch_acceleration := 0.0015

@export var linear_acceleration := 3.0
@export var axis_acceleration := 0.25
@export var precession := 0.0

@export var linear_velocity: Vector3
@export var downward_velocity: float

@export_group("Internal")
@export var visuals: Node3D
@export var ragdoll_self: PackedScene

@export var angular_velocity_real: float
@export var precession_real: float


func _ready() -> void:
	linear_velocity = Vector3.FORWARD * 6.0
	EntityManager.subscribe(self, 16.0)


func _physics_process(dt: float) -> void:
	print(linear_velocity)
	
	if is_zero_approx(global_position.y) and linear_velocity.length() > 1.0:
		linear_velocity *= 0.99
	if Input.is_action_pressed("mecha_forward"):
		linear_velocity += linear_velocity.normalized() * dt * linear_acceleration
	
	linear_velocity = linear_velocity.rotated(Vector3.UP, precession_real / (18 * TAU))
	
	if Input.is_action_pressed("mecha_launch"):
		downward_velocity += launch_acceleration * dt
	else:
		downward_velocity += -GRAVITY * dt
	angular_velocity += angular_acceleration / (1.0 + angular_velocity) * dt
	angular_position += angular_velocity_real * dt
	
	precession *= 0.995
	
	if is_zero_approx(global_position.y):
		if Input.is_action_pressed("mecha_tilt_left"):
			precession = precession + velocity.length() * dt * axis_acceleration
		if Input.is_action_pressed("mecha_tilt_right"):
			precession = precession - velocity.length() * dt * axis_acceleration
	
	global_transform = Transform3D.IDENTITY \
		.looking_at(velocity, Vector3.UP) \
		.rotated_local(Vector3.FORWARD, -precession_real / PI) \
		.rotated_local(Vector3.RIGHT, -sqrt(sqrt(velocity.length())) / TAU) \
		.translated(global_position)
	
	visuals.transform = Transform3D.IDENTITY.rotated(Vector3.UP, angular_position)
	
	var collision := move_and_collide(velocity * dt)
	if null != collision:
		for i in collision.get_collision_count():
			if collision.get_collider(i) is Monster:
				angular_velocity = maxf(angular_velocity - velocity.length() / PI, 0.0)
				ImpactManager.create_impact(velocity.length())
				var n := collision.get_normal(i)
				var real_n := Vector3(n.x, 0.0, n.z).normalized()
				print("REAL_N", real_n)
				linear_velocity = linear_velocity.bounce(real_n)
	
	global_position.y += downward_velocity
	if global_position.y < 0.0:
		global_position.y = 0.0
		downward_velocity = 0.0
	
	velocity = lerp(velocity, linear_velocity, 0.5)
	angular_velocity_real = lerp(angular_velocity_real, angular_velocity, 0.05)
	precession_real = lerp(precession_real, precession, 0.05)
	
	if angular_velocity_real <= 0.0:
		_swap_with_ragdoll()
		return
	
	if absf(precession_real) > angular_velocity_real or absf(precession_real) > 1.85:
		_swap_with_ragdoll()
		return


func _swap_with_ragdoll() -> void:
	var target := owner
	var t := global_transform
	var ragdoll := ragdoll_self.instantiate() as RigidBody3D
	ragdoll.linear_velocity = linear_velocity + Vector3(randfn(0.0, 0.5), randfn(0.0, 0.5), randfn(0.0, 0.5))
	ragdoll.angular_velocity = Vector3(0, angular_velocity_real, 0)
	get_parent_node_3d().remove_child(self)
	queue_free()
	target.add_child(ragdoll)
	ragdoll.global_transform = t
