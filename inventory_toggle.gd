extends CanvasLayer

@onready var inventory_ui: Control = $Inventory

var inventory_open := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	inventory_ui.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey \
	and event.pressed \
	and not event.echo \
	and event.keycode == KEY_I:

		toggle_inventory()
		get_viewport().set_input_as_handled()


func toggle_inventory() -> void:
	inventory_open = not inventory_open
	inventory_ui.visible = inventory_open

	if inventory_open:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
