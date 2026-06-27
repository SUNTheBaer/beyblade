class_name Monster
extends StaticBody2D

@export var active: bool = false
@export var hp: float = 1.0: set = _set_hp
@export var player: PlayerMech
@export var target_velocity: Vector2
@export var impact_velocity: Vector2
@export var rotation_speed: float = PI / 4.0
@export var shooting_laser: bool = false: set = _set_shooting_laser
@export var leap: bool = false: set = _set_leap
@export var leap_distance: float = 100.0

@export_group("Internal")
@export var body: AnimatedSprite2D
@export var shadow: AnimatedSprite2D
@export var laser_scene: PackedScene

var monster_speed: float = 128.0
var monster_stun_multiplier: float = 5.0
var monster_stun_time: float = 2.0
var laser_: MonsterLaser

func _set_hp(value: float) -> void:
	hp = clampf(value, 0.0, 1.0)
	if hp <= 0.0:
		if not Data.victory:
			AudioManager.switch_music(null, 3.0)
		Data.victory = true


func _set_shooting_laser(value: bool) -> void:
	if shooting_laser == value:
		return
	if value and not is_zero_approx(impact_velocity.length()):
		return
	shooting_laser = value
	if shooting_laser:
		print("Initiate laser shot")
		AudioManager.play_sound(load("res://Assets/KK roar.wav"), "world_sfx")
		body.play("laser")
		body.animation_finished.connect(_shoot_laser)
	else:
		if body.animation_finished.is_connected(_shoot_laser):
			body.animation_finished.disconnect(_shoot_laser)
		if null != laser_:
			laser_.cancel()

func _set_leap(value: bool) -> void:
	if leap == value:
		return
	if value and not is_zero_approx(impact_velocity.length()):
		return
	leap = value
	if leap:
		print("Initiating leap")
		body.play("leap")
		body.animation_finished.connect(_leap)


func impact(velocity: Vector2) -> void:
	impact_velocity = velocity
	shooting_laser = false


func _ready() -> void:
	EntityManager.subscribe(self, 480.0)
	body.play()


func _process(dt: float) -> void:
	if not active:
		return
	
	if _should_fire_laser():
		shooting_laser = true
	
	if _should_leap():
		leap = true
	
	dt *= Data.get_time()
	body.speed_scale = Data.get_time()
	shadow.speed_scale = Data.get_time()
	
	if not is_zero_approx(impact_velocity.length()):
		global_position += impact_velocity * dt
		impact_velocity *= 0.9
		body.animation = "default"
	elif shooting_laser:
		_target_player(dt, 500.0 / global_position.distance_to(player.global_position))
		target_velocity = Vector2()
	else:
		_target_player(dt)
		target_velocity = Vector2.from_angle(rotation) * monster_speed
		if not is_zero_approx(target_velocity.length()):
			if body.animation != "walk":
				body.play("walk")
			global_position += target_velocity * dt
		else:
			body.animation = "default"
	
	shadow.animation = body.animation
	shadow.frame = body.frame
	shadow.global_position = global_position + Data.sun_direction * 32.0


func stun_monster():
	monster_speed /= monster_stun_multiplier
	await get_tree().create_timer(monster_stun_time).timeout
	monster_speed *= monster_stun_multiplier


func _target_player(dt: float, mult: float = 1.0) -> void:
	var target_rotation := (player.global_position - global_position).angle()
	var diff := angle_difference(target_rotation, rotation)
	var rot := rotation_speed * dt * mult
	rotation = target_rotation if absf(diff) < rot else rotation - rot * sign(diff)


func _shoot_laser() -> void:
	if not shooting_laser:
		return
	
	print("Fire laser!")
	body.animation_finished.disconnect(_shoot_laser)
	laser_ = laser_scene.instantiate() as MonsterLaser
	laser_.position = Vector2(480.0, 0.0)
	laser_.tree_exiting.connect(func() -> void:
		if not shooting_laser:
			return
		print("Laser done, winding down")
		body.play_backwards("laser")
		body.animation_finished.connect(_finish_laser)
		laser_ = null
		)
	add_child(laser_)


func _finish_laser() -> void:
	if not shooting_laser:
		return
	
	print("Back to business")
	body.animation_finished.disconnect(_finish_laser)
	shooting_laser = false


func _should_fire_laser() -> bool:
	if randf() > 0.000:
		return false
	var d := global_position.distance_to(player.global_position)
	return d > 1800 and d < 4000


func _leap() -> void:
	if not leap:
		return
	
	print("Leaping!")
	body.animation_finished.disconnect(_leap)
	var leap_vector = (player.global_position - global_position).normalized()
	print(leap_vector)
	var target_position = leap_vector * leap_distance
	print(target_position) 
	var t = 1.5
	global_position = global_position.lerp(target_position, t)


func _finish_leap() -> void:
	if not shooting_laser:
		return
	
	print("Back to business")
	body.animation_finished.disconnect(_finish_laser)
	shooting_laser = false


func _should_leap() -> bool:
	if randf() > 1:
		return false
	var d := global_position.distance_to(player.global_position)
	return d > 400 and d < 1800
