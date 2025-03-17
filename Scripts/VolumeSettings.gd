extends Node

@export_group("Sound", "sound")
@export var sound_slider : HSlider
@export var sound_label : Label
@export var sound_button : Button

@export_group("Music", "music")
@export var music_player : AudioStreamPlayer
@export var music_slider : HSlider
@export var music_label : Label
@export var music_button : Button

var sound_vol : float = 50.0
var sound_vol_min : float = -25.0
var sound_vol_range : float = 35.0
var sound_translation : float: 
	get: 
		return sound_vol_range / 100.0

var music_vol : float = 40.0
var music_vol_min : float = -25.0
var music_vol_range : float = 35.0
var music_translation : float: 
	get: 
		return sound_vol_range / 100.0

var settings_path = "user://settings.json"
var settings_data : Dictionary

func _ready():
	if load_volume() == false:
		sound_slider.value = sound_vol
		music_slider.value = music_vol


#region Sound

func set_sound_vol(value, save : bool = true):
	sound_vol = value * sound_translation + sound_vol_min
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), sound_vol)
	sound_label.text = str(value)
	if save: save_volume()

func set_sound_silenced(silenced : bool):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), silenced)

func _on_sound_h_slider_value_changed(value):
	set_sound_vol(value)

func _on_sound_h_slider_drag_ended(value_changed):
	if value_changed:
		sound_button.button_pressed = sound_vol <= sound_vol_min

func _on_sound_button_toggled(toggled_on):
	set_sound_silenced(toggled_on)

#endregion

#region Music

func set_music_vol(value, save : bool = true):
	music_vol = value * music_translation + music_vol_min
	if music_player: music_player.volume_db = music_vol
	music_label.text = str(value)
	if save: save_volume()

func set_music_silenced(silenced : bool):
	if music_player: music_player.playing = !silenced

func _on_music_h_slider_value_changed(value):
	set_music_vol(value)

func _on_music_h_slider_drag_ended(value_changed):
	if value_changed:
		music_button.button_pressed = music_vol <= music_vol_min

func _on_music_button_toggled(toggled_on):
	set_music_silenced(toggled_on)

#endregion

#region Save/Load

func save_volume():
	settings_data = {
		"sound_volume" : sound_vol,
		"music_volume" : music_vol,
	}
	var file_access = FileAccess.open(settings_path, FileAccess.WRITE)
	if not file_access:
		print("An error happened while saving data: ", FileAccess.get_open_error())
		return
	
	file_access.store_line(JSON.stringify(settings_data))
	file_access.close()

func load_volume() -> bool:
	if not FileAccess.file_exists(settings_path):
		return false
	var file_access = FileAccess.open(settings_path, FileAccess.READ)
	var json_string = file_access.get_line()
	file_access.close()
	
	if json_string == "{}":
		print("Settings data is empty.")
		return false
	
	var json = JSON.new()
	var error = json.parse(json_string)
	if error:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return false
	
	settings_data = json.data
	sound_vol = settings_data["sound_volume"]
	var sound_value = (sound_vol - sound_vol_min) / sound_translation
	music_vol = settings_data["music_volume"]
	var music_value = (music_vol - music_vol_min) / music_translation
	sound_slider.value = sound_value
	music_slider.value = music_value
	
	return true

#endregion
