#THIS SHOULD PROBABLY WORK FOR EVERY NPC. PUT THEIR DIALOGUE IN THE INSPECTOR
extends Node3D
const TextBox_SCENE = preload("res://UI/text_box.tscn")
@export var main_dialogue: Array[String] = []
@export var exhausted_dialogue: Array[String] = []
@export var collision_area: Area3D
#attach npcScript to each NPC node, drag each NPCS interactionArea into the Collision Area

var displayed_dialogue: Array[String] = []
var player_in_range: bool = false
var active_textbox: Control = null
var current_line: int = 0
var dialogue_exhausted: bool = false



func _ready() -> void:
	collision_area.body_entered.connect(_on_player_entered)
	collision_area.body_exited.connect(_on_player_exited)

func _process(_delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("Interact"):
			if active_textbox == null:
				trigger_dialogue()
			else:
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
	if dialogue_exhausted == true:
		displayed_dialogue = exhausted_dialogue
		print(name, " opened dialogue")
	else:
		displayed_dialogue = main_dialogue
	var textBox = TextBox_SCENE.instantiate()
	add_child(textBox)
	active_textbox = textBox
	display_text(displayed_dialogue[current_line])
	
func advance_dialogue() -> void:
	if active_textbox != null:
		current_line += 1
		if current_line < displayed_dialogue.size():
			display_text(displayed_dialogue[current_line])
		else:
			dialogue_exhausted = true
			close_dialogue()

func display_text(new_text: String) -> void:
	var label: RichTextLabel = active_textbox.get_node("CanvasLayer/Panel/MarginContainer/VBoxContainer/RichTextLabel")
	label.text = new_text

func close_dialogue() -> void:
	if active_textbox != null:
		active_textbox.queue_free()
		active_textbox = null
