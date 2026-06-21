class_name CameraArm
extends Node3D

@export var top_down: bool = false
@export var mecha: PlayerMecha
@export var connecter: Node3D
@export var camera: Camera3D


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("mecha_switch_view"):
		top_down = not top_down


func _physics_process(dt: float) -> void:
	if null == mecha:
		return
	
	if mecha.is_queued_for_deletion():
		mecha = null
		return
	
	if top_down:
		var t := Transform3D.IDENTITY.translated(Vector3(0, 48.0, 0)).looking_at(Vector3(), Vector3.FORWARD)
		connecter.transform = connecter.transform.interpolate_with(t, 0.05)
	else:
		var t := Transform3D.IDENTITY.looking_at(Vector3() + mecha.velocity, Vector3.UP).translated_local(Vector3(0, 24, 36))
		connecter.transform = connecter.transform.interpolate_with(t, 0.01)
		connecter.transform = connecter.transform.looking_at(Vector3(0, 2, 0), Vector3.UP)
	
	var x := minf(0.25, pow(ImpactManager.impact, 4.0) / 10.0)
	camera.position = Vector3(randfn(0.0, x), randfn(0.0, x), randfn(0.0, x))
	global_position = mecha.global_position
