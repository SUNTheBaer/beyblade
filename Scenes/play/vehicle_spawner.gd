extends Node2D

@export var potential_vehicles: Array[PackedScene]
@export var potential_paths: Array[Path2D]
@export var spawning_timer: float = 1.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#await get_tree().create_timer(spawning_timer).timeout
	#var current_vehicle = potential_vehicles.pick_random().instantiate() as Vehicle
	#current_vehicle.navigation_agent_2d = potential_paths.pick_random()
	
