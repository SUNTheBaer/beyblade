class_name Monster
extends StaticBody3D

@export var player: PlayerMecha


func _ready() -> void:
	EntityManager.subscribe(self, 16.0)


func _process(delta: float) -> void:
	if player == null:
		return
	
	if player.is_queued_for_deletion():
		player = null
		return
	
	# visible = (player.global_position - global_position).normalized().dot(player.velocity.normalized()) < 0.0
		
