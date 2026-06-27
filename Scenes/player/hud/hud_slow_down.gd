class_name HUDSlowDown
extends Control

var array_: Array[Node]



func register(who: Node, what: bool) -> void:
	if what:
		if who in array_:
			return
		array_.push_back(who)
	else:
		if who not in array_:
			return
		array_.erase(who)


func _ready() -> void:
	_process(0.0)


func _process(__: float) -> void:
	visible = array_.size() > 0
