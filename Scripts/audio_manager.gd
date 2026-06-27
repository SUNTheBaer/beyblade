extends Node

signal no_signal

@export var music_volume: float = 0.0
@export var sfx_volume: float = 1.0

var music_stream_player: AudioStreamPlayer

var export_override_volume: float = 0.0
var window_focused: bool = false
var audio_map: Dictionary[int, AudioStreamPlayer]
var audio_value: int = 1

var master_bus: int = AudioServer.get_bus_index("Master")


func switch_music(audio: AudioStream, transition: float = 1.0) -> void:
	print("switching music to: ")
	print(audio)
	if null != music_stream_player.stream:
		var tween_out := create_tween()
		tween_out.tween_property(self, "music_volume", 0.0, transition)
		await tween_out.finished
	else:
		music_volume = 0.0

	music_stream_player.stream = audio
	music_stream_player.play()

	if null != music_stream_player.stream:
		var tween_in := create_tween()
		tween_in.tween_property(self, "music_volume", 1.0, transition)
	else:
		music_volume = 1.0


func pulse(to: float, transition: float = 0.0) -> Signal:
	var tween := create_tween()
	tween.tween_property(self, "music_volume", to, transition)
	return tween.finished


func play_sound(audio: AudioStream, bus: String = "sfx", volume: float = 1.0) -> Signal:
	if null == audio:
		return no_signal
	var sfx_stream_player := AudioStreamPlayer.new()
	sfx_stream_player.pitch_scale = randf_range(0.9, 1.1)
	sfx_stream_player.stream = audio
	sfx_stream_player.bus = bus
	sfx_stream_player.volume_linear = volume
	sfx_stream_player.finished.connect(sfx_stream_player.queue_free)
	add_child(sfx_stream_player)
	sfx_stream_player.play()
	return sfx_stream_player.finished


func play_persistent_sound(audio: AudioStream, bus: String = "sfx") -> int:
	if null == audio:
		return 0
	var sfx_id := audio_value
	audio_value += 1
	var sfx_stream_player := AudioStreamPlayer.new()
	sfx_stream_player.stream = audio
	sfx_stream_player.bus = bus
	add_child(sfx_stream_player)
	sfx_stream_player.play()
	audio_map[sfx_id] = sfx_stream_player
	return sfx_id


func stop_persistent_sound(id: int) -> bool:
	if id not in audio_map:
		return false
	var player := audio_map[id]
	audio_map.erase(id)
	if null == player:
		return false
	player.queue_free()
	return true


func stop_all_sounds() -> void:
	for id in audio_map:
		var player := audio_map[id]
		if null == player:
			continue
		player.queue_free()
	audio_map.clear()


func _ready() -> void:
	music_stream_player = AudioStreamPlayer.new()
	music_stream_player.bus = "music"
	add_child(music_stream_player)


func _notification(what: int) -> void:
	if not is_inside_tree():
		return
	
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		window_focused = false
	elif what == NOTIFICATION_APPLICATION_FOCUS_IN:
		window_focused = true


func _process(dt: float) -> void:
	if window_focused and export_override_volume < 1.0:
		export_override_volume = minf(1.0, export_override_volume + dt)
		AudioServer.set_bus_volume_linear(master_bus, export_override_volume)
	elif not window_focused and export_override_volume > 0.0:
		export_override_volume = maxf(0.0, export_override_volume - dt)
		AudioServer.set_bus_volume_linear(master_bus, export_override_volume)
	
	music_stream_player.volume_linear = music_volume
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("world_sfx"), Data.get_time())
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("alarm_sfx"), Data.get_time() / 2.0)
