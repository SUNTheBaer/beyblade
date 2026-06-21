extends Minigame

@onready var full_sequence: HBoxContainer = %FullSequence

var sequence_elements: Array[Node]
@export var arrow_textures: Array[CompressedTexture2D] = []

const WRONG_COLOR: Color = Color(Color.FIREBRICK, 0.5)
const CORRECT_COLOR: Color = Color(Color.FOREST_GREEN, 0.5)

func _ready() -> void:
	super._ready()
	sequence_elements = full_sequence.get_children() as Array[Node]
	for element in sequence_elements:
		element.texture = arrow_textures.pick_random()

func _physics_process(delta: float) -> void:
	pass
