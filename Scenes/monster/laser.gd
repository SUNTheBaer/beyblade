class_name MonsterLaser
extends Area2D

@export var zenith_time: float = 8.0
@export var increase_time: float = 1.0
@export var increase_curve: Curve
@export var decrease_time: float = 1.0
@export var decrease_curve: Curve
@export var luminance: float = 0.5
@export var width: float = 128.0
@export var length: float = 3000.0
@export var color: Color = Color.WHITE

@export_group("Internal")
@export var global_material: ShaderMaterial
@export var collision_shape: CollisionShape2D

var real_width_: float = 0.0
var accum_: float = 0.0
var state_: int = 0


func cancel() -> void:
	if state_ == 0:
		accum_ = 1.0 - accum_
	elif state_ == 1:
		accum_ = 0.0
	else:
		return
	
	state_ = 2


func _ready() -> void:
	EntityManager.subscribe_line(self, width)
	AudioManager.play_sound(load("res://Assets/laser 3 seconds.mp3"))
	var s := RectangleShape2D.new()
	s.size = Vector2(length, real_width_)
	collision_shape.shape = s
	collision_shape.position = Vector2(length / 2.0, 0.0)


func _process(dt: float) -> void:
	dt *= Data.get_time()
	
	var ratio := 1.0
	match state_:
		0:
			accum_ = minf(1.0, accum_ + dt / increase_time)
			ratio = increase_curve.sample_baked(accum_) if null != increase_curve else accum_
			if accum_ >= 1.0:
				accum_ = 0.0
				state_ = 1
		1:
			accum_ = minf(1.0, accum_ + dt / zenith_time)
			if accum_ >= 1.0:
				accum_ = 0.0
				state_ = 2
		2:
			accum_ = minf(1.0, accum_ + dt / decrease_time)
			ratio = decrease_curve.sample_baked(accum_) if null != decrease_curve else 1.0 - accum_
			if accum_ >= 1.0:
				queue_free()
	
	real_width_ = ratio * width
	global_material.set_shader_parameter("target_mix", luminance * ratio)
	collision_shape.shape.size = Vector2(length, real_width_)
	
	queue_redraw()


func _physics_process(dt: float):
	if has_overlapping_areas():
		var areas := get_overlapping_areas()
		for area in areas:
			_kill_skyscraper(area)
	if has_overlapping_bodies():
		var bodies := get_overlapping_bodies()
		for body in bodies:
			if body is PlayerMech:
				var dist: float = (body.global_position.x - global_position.x) * cos(PI / 2.0 - global_rotation) \
					- (body.global_position.y - global_position.y) * sin(PI / 2.0 - global_rotation)
				if absf(dist) < 1.0:
					dist = randi_range(0, 1) * 2 - 1
				body.linear_velocity = sign(dist) * Vector2.from_angle(global_rotation - PI / 2.0) * maxf(body.global_position.distance_to(global_position), body.linear_velocity.length())
				body.angular_velocity = maxf(0.0, body.angular_velocity - body.angular_acceleration * 24.0 * dt)
				body.inflict_damage(0.1)


func _draw() -> void:
	draw_circle(Vector2(), real_width_ / 2.0, color)
	draw_rect(Rect2(Vector2(0.0, -real_width_ / 2.0), Vector2(length, real_width_)), color)
	draw_circle(Vector2(length, 0.0), real_width_ * 0.6, color)


func _kill_skyscraper(area: Area2D) -> void:
	var sky := area.get_parent() as Skyscraper
	if null == sky:
		return
	sky.collapse_me(self)
	
