class_name Vehicle
extends CharacterBody2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var possible_vehicles: Array[CompressedTexture2D]
@export var movement_speed: float = 100.0
@export var Goal: Node = null

func _ready() -> void:
	sprite_2d.texture = possible_vehicles.pick_random()
	#navigation_agent_2d.target_position = Goal.global_position


#func _process(delta: float) -> void:
	#if navigation_agent_2d != null and navigation_agent_2d.is_target_reached():
		#var nav_point_direction = to_local(navigation_agent_2d.get_next_path_position()).normalized()
		#velocity = nav_point_direction * movement_speed * delta
		#move_and_slide()
