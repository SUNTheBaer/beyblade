class_name RagdollController
extends RigidBody3D


func _ready() -> void:
	EntityManager.subscribe(self, 12.0)
