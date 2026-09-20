#THIS SHOULD PROBABLY WORK FOR EVERY NPC. PUT THEIR DIALOGUE IN THE INSPECTOR
extends Node3D
const TextBox_SCENE = preload("res://UI/text_box.tscn")
const CoinFlip = preload("res://SCRIPTS/coinFlip.gd")
const HEADS_IMG = preload("res://2D ASSETS/heads.png")
const TAILS_IMG = preload("res://2D ASSETS/tails.png")
#these let you edit things in the inspect section
#regular dialogue variables
@export var main_dialogue: Array[String] = []
@export var exhausted_dialogue: Array[String] = []
@export var collision_area: Area3D

#combat variables
@export var choices: Array[String] = []
@export var win_dialogue: Array[String] = []
@export var lose_dialogue: Array[String] = []
@export var coin_flip_combat: int = -1
@export var wins_amount: int = 1

#attach npcScript to each NPC node, drag each NPCS interactionArea into the Collision Area

var displayed_dialogue: Array[String] = []
var player_in_range: bool = false
var active_textbox: Control = null
var current_line: int = 0
var dialogue_exhausted: bool = false
var choices_open: bool = false
var choice_dialogue_active: bool = false
var wins_count: int = 0

func _ready() -> void:
	collision_area.body_entered.connect(_on_player_entered)
	collision_area.body_exited.connect(_on_player_exited)

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("Interact"):
		if active_textbox == null:
			trigger_dialogue()
		elif not choices_open:
			advance_dialogue()

func _on_player_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	player_in_range = true

func _on_player_exited(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	player_in_range = false
	close_dialogue()

func trigger_dialogue() -> void:
	current_line = 0
	choice_dialogue_active = false
	if dialogue_exhausted == true:
		displayed_dialogue = exhausted_dialogue
		print(name, " opened dialogue")
	else:
		displayed_dialogue = main_dialogue
	var textBox = TextBox_SCENE.instantiate()
	add_child(textBox)
	active_textbox = textBox
	var player = get_tree().get_first_node_in_group("player")
	player.set_physics_process(false)
	player.set_process_unhandled_input(false)
	display_text(displayed_dialogue[current_line])

func advance_dialogue() -> void:
	if active_textbox == null:
		return
	current_line += 1
	if current_line < displayed_dialogue.size():
		display_text(displayed_dialogue[current_line])
	elif choices.size() > 0 and not choice_dialogue_active and not dialogue_exhausted:
		show_choices()
	else:
		dialogue_exhausted = true
		close_dialogue()

func show_choices() -> void:
	var choices_box: VBoxContainer = active_textbox.get_node("CanvasLayer/Panel/MarginContainer/VBoxContainer/ChoicesBox")

	for child in choices_box.get_children():
		child.queue_free()

	for choice_index in choices.size():
		var button := Button.new()
		button.text = choices[choice_index]
		button.pressed.connect(_on_choice_selected.bind(choice_index))
		choices_box.add_child(button)

	choices_open = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().get_first_node_in_group("player").set_process_input(false) 

func _on_choice_selected(choice_index: int) -> void:
	var choices_box: VBoxContainer = active_textbox.get_node("CanvasLayer/Panel/MarginContainer/VBoxContainer/ChoicesBox")

	for child in choices_box.get_children():
		child.queue_free()

	choices_open = false
	dialogue_exhausted = false
	current_line = 0
	displayed_dialogue.clear()

	var player_choice = choices[choice_index]
	var coin_result = CoinFlip.flip_coin()
	show_coin_result(coin_result)
	
	if player_choice == coin_result:
		wins_count += 1
		update_win_counter()
		displayed_dialogue = win_dialogue.duplicate()
		choice_dialogue_active = wins_count >= wins_amount
	else:
		update_win_counter()
		displayed_dialogue = lose_dialogue.duplicate()
		choice_dialogue_active = false
	
	if displayed_dialogue.size() > 0:
		display_text(displayed_dialogue[current_line])
	else:
		close_dialogue()

func show_coin_result(coin_result: String) -> void:
	var coin_image: TextureRect = active_textbox.get_node("CanvasLayer/VBoxContainer/CoinImage")

	if coin_result == "Heads":
		coin_image.texture = HEADS_IMG
	else:
		coin_image.texture = TAILS_IMG

	coin_image.visible = true

func update_win_counter() -> void:
	var panel: Panel = active_textbox.get_node("CanvasLayer/Panel2")
	var counter: Label = active_textbox.get_node("CanvasLayer/Panel2/MarginContainer/VBoxContainer/WinCounter")
	counter.text = "Wins: " + str(wins_count) + " / " + str(wins_amount)
	panel.visible = true

func display_text(new_text: String) -> void:
	var label: RichTextLabel = active_textbox.get_node("CanvasLayer/Panel/MarginContainer/VBoxContainer/RichTextLabel")
	label.text = new_text

func close_dialogue() -> void:
	if active_textbox != null:
		active_textbox.queue_free()
		active_textbox = null	
		get_tree().get_first_node_in_group("player").set_process_input(true)
		var player = get_tree().get_first_node_in_group("player")
		player.set_physics_process(true)
		player.set_process_unhandled_input(true)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
