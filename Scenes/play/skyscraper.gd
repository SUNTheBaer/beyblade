class_name Skyscraper
extends Node2D

static var IMPACT_CURVE: Curve = load("res://Scenes/play/skyscraper_impact_curve.tres")
static var COLLISION_SFX: Array[AudioStream] = [
	load("res://Assets/boom 1.mp3"),
	load("res://Assets/boom 2.mp3"),
	load("res://Assets/boom 3.mp3"),
	load("res://Assets/boom 4.mp3"),
	load("res://Assets/boom 5.mp3")
]

@export var height: int = 1
@export var vertical_texture: Texture2D
@export var collapsing: bool = false
@export var collapse: float = 0.0
@export var area: Area2D
@export var shape: CollisionShape2D

var sprites_: Array[Node2D]
var velocities_: Array[Vector2]
var offsets_: Array[Vector2]

func _ready() -> void:
	area.body_entered.connect(_collapse_me)
	for i in height:
		var sprite := Sprite2D.new()
		sprite.texture = vertical_texture
		sprite.z_index = i + 1
		sprites_.push_back(sprite)
		velocities_.push_back(Vector2())
		offsets_.push_back(Vector2())
		add_child(sprite)


func _process(dt: float) -> void:
	dt *= Data.time_scale
	
	shape.disabled = not EntityManager.in_range(global_position)
	
	if collapse >= 1.0:
		for s in sprites_:
			s.queue_free()
		sprites_.clear()
		return
	
	if collapsing:
		collapse += (collapse + 1.0) * dt
		
	var radius := (get_viewport_rect().size / 2.0).length()
	var d := (global_position - get_viewport().get_camera_2d().global_position) / radius
	var c := maxf(0.0, 1.0 - collapse)
	for i in sprites_.size():
		var s := sprites_[i]
		s.z_index = floori(i + 1 - collapse)
		velocities_[i] *= 0.999
		offsets_[i] += velocities_[i] * dt
		s.position = 24.0 * i * d * c + offsets_[i]
		s.self_modulate.a = c


func _collapse_me(node: Node2D) -> void:
	if collapsing:
		return
	var velocity: Vector2 = node.velocity if node is PlayerMech else Vector2(0, 0)
	collapsing = true
	var d := velocity.normalized().dot((global_position - node.global_position).normalized())
	ImpactManager.create_impact(height * maxf(1.0, velocity.length()) * d, 0.25, IMPACT_CURVE)
	for i in sprites_.size():
		velocities_[i] = (velocity + Vector2(randf_range(-128.0, 128.0), randf_range(-128.0, 128.0))) * i / 10.0
	AudioManager.play_sound(COLLISION_SFX.pick_random())
	_set_disabled.call_deferred()


func _set_disabled() -> void:
	shape.disabled = true
