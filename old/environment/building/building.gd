class_name Building
extends Node3D

@export var width: int = 1
@export var depth: int = 1
@export var height: int = 2

@export_group("Internal")
@export var mesh_instance: MeshInstance3D
@export var collider: CollisionShape3D
@export var area: Area3D

var accum_: float


func _ready() -> void:
	var size := Vector3(width, height, depth)
	
	var box_mesh := BoxMesh.new()
	box_mesh.size = size
	
	var box_shape := BoxShape3D.new()
	box_shape.size = size
	
	mesh_instance.mesh = box_mesh
	collider.shape = box_shape
	
	mesh_instance.position = size / 2.0
	collider.position = size / 2.0
	
	area.body_entered.connect(_body_entered)


func _process(dt: float) -> void:
	dt *= Data.time_scale
	accum_ += dt
	if accum_ > 0.25:
		collider.disabled = not EntityManager.in_range(global_position)
		accum_ -= 0.25


func _body_entered(_body: Node3D) -> void:
	ImpactManager.create_impact(0.01 * width * depth * height)
	queue_free()
