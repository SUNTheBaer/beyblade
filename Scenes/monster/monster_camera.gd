class_name MonsterCamera
extends Camera2D

@export var player: PlayerMech
@export var monster: Monster


func _ready() -> void:
	_ready_deferred.call_deferred()


func _ready_deferred() -> void:
	make_current()


func _process(__: float) -> void:
	if not monster.active:
		global_position = player.global_position
		return
	global_position = monster.global_position
