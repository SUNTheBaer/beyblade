class_name TVNoise
extends TextureRect

var noise_: FastNoiseLite

func _ready() -> void:
	noise_ = (texture as NoiseTexture2D).noise as FastNoiseLite


func _process(__: float) -> void:
	noise_.seed += 1
