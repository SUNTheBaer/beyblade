extends Node

@export var entities: Dictionary[Node2D, float]
@export var line_entities:  Dictionary[Node2D, float]


func in_range(where: Vector2) -> bool:
	for e in entities:
		if where.distance_squared_to(e.global_position) < entities[e]:
			return true
	for e in line_entities:
		var d: float = absf((where.x - e.global_position.x) * cos(PI / 2.0 - e.global_rotation) \
			- (where.y - e.global_position.y) * sin(PI / 2.0 -e.global_rotation))
		if d < line_entities[e]:
			return true
	return false


func subscribe(ent: Node2D, radius: float) -> void:
	if ent in entities:
		return
	ent.tree_exiting.connect(_remove.bind(ent))
	entities[ent] = radius * radius


func subscribe_line(ent: Node2D, distance: float) -> void:
	if ent in entities:
		return
	ent.tree_exiting.connect(_remove.bind(ent))
	line_entities[ent] = distance


func unsubscribe(ent: Node2D) -> void:
	if ent not in entities and ent not in line_entities:
		return
	ent.tree_exiting.disconnect(_remove)
	_remove(ent)


func _remove(ent: Node2D) -> void:
	entities.erase(ent)
	line_entities.erase(ent)
