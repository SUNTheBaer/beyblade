extends Control
class_name GlobalSceneManager

enum SCENE {
	PLAY,
	VICTORY
}

var scene_map_: Dictionary
var fname_map_: Dictionary


func register(fname: String, scene: SCENE):
	scene_map_[fname] = scene
	fname_map_[scene] = fname


func _ready() -> void:
	z_index = 1
	process_mode = PROCESS_MODE_ALWAYS
	
	register("res://Scenes/play/arena.tscn",	SCENE.PLAY)
	register("res://Scenes/victory.tscn", 		SCENE.VICTORY)


func reload_scene() -> void:
	go_to_scene(_get_scene_from_filename(get_tree().current_scene.scene_file_path))


func go_to_scene(scene: SCENE) -> void:
	get_tree().paused = false
	Engine.time_scale = 1.0
	var fname := _get_filename_from_scene(scene)
	var err := get_tree().change_scene_to_file(fname)
	if OK != err:
		push_error("Scene " + str(scene) + " is misconfigured")
		get_tree().change_scene_to_file("res://Scenes/router.tscn")


func _get_scene_from_filename(fname: String) -> SCENE:
	if scene_map_.has(fname):
		return scene_map_[fname]
	else:
		push_error("Invalid scene '" + fname + "'")
		return SCENE.PLAY


func _get_filename_from_scene(scene: SCENE) -> String:
	if fname_map_.has(scene):
		return fname_map_[scene]
	else:
		push_error("Invalid scene '" + str(scene) + "'")
		return "res://Scenes/router.tscn"
