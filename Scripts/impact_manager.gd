extends Node

@export var impact: float

var impacts_curve_: Array[Curve]
var impacts_mag_: PackedFloat32Array
var impacts_duration_: PackedFloat32Array
var impacts_accum_: PackedFloat32Array


func create_impact(mag: float = 1.0, duration: float = 0.1, curve: Curve = null) -> void:
	impacts_curve_.push_back(curve)
	impacts_mag_.push_back(mag)
	impacts_duration_.push_back(duration)
	impacts_accum_.push_back(0.0)


func _process(dt: float) -> void:
	dt *= Data.pause_scale
	
	impact = 0.0
	
	var to_remove: PackedInt32Array
	
	for i in impacts_curve_.size():
		var ratio := impacts_accum_[i] / impacts_duration_[i]
		var value := impacts_curve_[i].sample_baked(ratio) if null != impacts_curve_[i] else ratio
		impact += value * impacts_mag_[i]
		impacts_accum_[i] += dt
		if impacts_accum_[i] >= impacts_duration_[i]:
			to_remove.insert(0, i)
	
	for i in to_remove:
		impacts_curve_.remove_at(i)
		impacts_mag_.remove_at(i)
		impacts_duration_.remove_at(i)
		impacts_accum_.remove_at(i)
