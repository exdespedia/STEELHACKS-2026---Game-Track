extends VBoxContainer

var master_bus_id: int
var music_bus_id: int
var sfx_bus_id: int

func _ready() -> void:
	master_bus_id = AudioServer.get_bus_index("Master")
	music_bus_id = AudioServer.get_bus_index("Music")
	sfx_bus_id = AudioServer.get_bus_index("SFX")

	$MasterVolume.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus_id))
	$MusicVolume.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_id))
	$SFXVolume.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_id))


func _on_master_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_id, linear_to_db(value))


func _on_music_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_id, linear_to_db(value))


func _on_sfx_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus_id, linear_to_db(value))
