class_name CityScape
extends Node

@export var width: int = 100
@export var height: int = 100

@export var block_width: int = 4
@export var block_height: int = 4

@export_group("Internal")
@export var building: PackedScene

func _ready() -> void:
	for y in height:
		if y % block_height == 0:
			continue
		for x in width:
			if x % block_width == 0:
				continue
			var struct := building.instantiate() as Building
			_configure.call_deferred(struct, x, y)


func _configure(struct: Building, x: int, y: int) -> void:
	struct.height = randi_range(1, 4)
	owner.add_child(struct)
	struct.global_position = Vector3((x - width / 2.0) * 1.1, 0, (y - height / 2.0) * 1.1)
