extends Control

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options: Panel = $Options
@onready var music: Panel = $Music
@onready var volume_sliders: VBoxContainer = $Music/VolumeSliders


func _ready() -> void:
	show_main_menu()


func show_main_menu() -> void:
	main_buttons.visible = true
	options.visible = false
	volume_sliders.visible = false
	music.visible = false


func _on_start_button_pressed() -> void:
	print("Start pressed")
	# Replace with your game scene:
	# get_tree().change_scene_to_file("res://path_to_game.tscn")


func _on_options_button_pressed() -> void:
	print("Options pressed")

	main_buttons.visible = false
	options.visible = true
	volume_sliders.visible = false
	music.visible = false


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_back_button_pressed() -> void:
	show_main_menu()


func _on_audio_settings_pressed() -> void:
	main_buttons.visible = false
	options.visible = false
	volume_sliders.visible = true
	music.visible = true


func _on_back_button_2_pressed() -> void:
	_on_options_button_pressed()
