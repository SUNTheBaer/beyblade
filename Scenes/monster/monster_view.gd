class_name MonsterView
extends SubViewport


func _ready() -> void:
	_ready_deferred.call_deferred()


func _ready_deferred() -> void:
	world_2d = get_tree().root.world_2d
