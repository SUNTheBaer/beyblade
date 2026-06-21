class_name ConeCollider
extends Node3D

@export var base_radius: float = 0.1
@export var top_radius: float = 1.5
@export var height: float = 2.0
@export var segments: int = 8

func _ready() -> void:
	var segment_height := height / segments
	var segment_radius := (top_radius - base_radius) / segments
	
	var init_shape := SphereShape3D.new()
	init_shape.radius = base_radius
	var init_collider := CollisionShape3D.new()
	init_collider.shape = init_shape
	get_parent().add_child.call_deferred(init_collider)
	init_collider.position = Vector3(0.0, 0.5 * segment_height, 0.0)
	
	for i in range(1, segments):
		var shape := CylinderShape3D.new()
		shape.radius = base_radius + i * segment_radius
		shape.height = segment_height
		var collider := CollisionShape3D.new()
		collider.shape = shape
		get_parent().add_child.call_deferred(collider)
		collider.position = Vector3(0.0, (i + 0.5) * segment_height, 0.0)
		
