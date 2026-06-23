extends Node

@export var entities: Dictionary[Node2D, float]


func in_range(where: Vector2) -> bool:
	for e in entities:
		if where.distance_squared_to(e.global_position) < entities[e]:
			return true
	return false


func subscribe(ent: Node2D, radius: float) -> void:
	if ent in entities:
		return
	ent.tree_exiting.connect(_remove.bind(ent))
	entities[ent] = radius * radius


func unsubscribe(ent: Node2D) -> void:
	if ent not in entities:
		return
	ent.tree_exiting.disconnect(_remove)
	_remove(ent)


func _remove(ent: Node2D) -> void:
	entities.erase(ent)
