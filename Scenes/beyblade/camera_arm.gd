class_name CameraArm
extends Node3D

@export var mecha: PlayerMecha
@export var camera: Camera3D

var arm_: Vector3


func _ready() -> void:
	arm_ = camera.global_position - mecha.global_position


func _physics_process(dt: float) -> void:
	rotation.y = mecha.axis_angle
	global_position = mecha.global_position
