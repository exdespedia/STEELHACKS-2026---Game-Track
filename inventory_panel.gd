extends Panel

const HAND_CLOSED = preload("res://ASSETS/kenney_cursor-pack/PNG/Basic/Default/hand_closed.png")
const HAND_POINT = preload("res://ASSETS/kenney_cursor-pack/PNG/Basic/Default/hand_point.png")

const ITEM_1 = preload("res://Gun.tres")
const ITEM_2 = preload("res://Dice.tres")
const ITEM_3 = preload("res://Joker.tres")



func _ready() -> void:
	
	print("INVENTORY READY")

	
	mouse_filter = Control.MOUSE_FILTER_STOP

	Input.set_custom_mouse_cursor(HAND_POINT, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(HAND_CLOSED, Input.CURSOR_FORBIDDEN)
	Input.set_custom_mouse_cursor(HAND_POINT, Input.CURSOR_CAN_DROP)
	Input.set_custom_mouse_cursor(HAND_POINT, Input.CURSOR_DRAG)

	# Starting inventory
	$MarginContainer/GridContainer/ItemSlot.item = ITEM_1
	$MarginContainer/GridContainer/ItemSlot.update_ui()

	$MarginContainer/GridContainer/ItemSlot2.item = ITEM_2
	$MarginContainer/GridContainer/ItemSlot2.update_ui()

	$MarginContainer/GridContainer/ItemSlot3.item = ITEM_3
	$MarginContainer/GridContainer/ItemSlot3.update_ui()

	$MarginContainer/GridContainer/ItemSlot2.item = ITEM_2
	$MarginContainer/GridContainer/ItemSlot2.update_ui()

	print("Dice icon = ", ITEM_2.icon)

var data_bk


func _notification(what: int) -> void:
	if what == Node.NOTIFICATION_DRAG_BEGIN:
		data_bk = get_viewport().gui_get_drag_data()

	if what == Node.NOTIFICATION_DRAG_END:
		if not is_drag_successful() and data_bk:
			data_bk.icon.show()
			data_bk = null
