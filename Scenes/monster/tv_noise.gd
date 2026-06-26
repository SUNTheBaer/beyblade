class_name TVNoise
extends TextureRect

@export var fps: int = 12

var noise_: FastNoiseLite
var accum_: float = 0.0

func _ready() -> void:
	noise_ = (texture as NoiseTexture2D).noise as FastNoiseLite


func _process(dt: float) -> void:
	var frame_time := 1.0 / fps
	dt *= Data.get_time()
	accum_ += dt
	while accum_ > frame_time:
		noise_.seed += 1
		accum_ -= frame_time
