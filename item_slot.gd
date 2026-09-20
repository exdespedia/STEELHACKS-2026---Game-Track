extends Panel

@export var item: ItemData

var icon: TextureRect


func _ready() -> void:
	# Get an existing Icon, if there is one.
	icon = get_node_or_null("Icon") as TextureRect

	# Otherwise create one.
	if icon == null:
		icon = TextureRect.new()
		icon.name = "Icon"
		add_child(icon)

	# Make the Icon layout identical for every slot.
	icon.anchor_left = 0.0
	icon.anchor_top = 0.0
	icon.anchor_right = 1.0
	icon.anchor_bottom = 1.0

	icon.offset_left = 10
	icon.offset_top = 10
	icon.offset_right = -10
	icon.offset_bottom = -10

	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon.z_index = 1

	update_ui()


func update_ui() -> void:
	if icon == null:
		return

	if item == null:
		icon.texture = null
		icon.hide()
		tooltip_text = ""
		return

	icon.texture = item.icon
	icon.tooltip_text = item.item_name
	icon.show()


func _get_drag_data(_at_position: Vector2) -> Variant:
	if item == null:
		return null

	var preview = duplicate()

	var c = Control.new()
	c.add_child(preview)

	preview.position -= Vector2(25, 25)
	preview.self_modulate = Color.TRANSPARENT
	preview.modulate = Color(preview.modulate, 0.5)

	set_drag_preview(c)

	icon.hide()

	return self


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Panel and data != self and data.get("item") != null


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if not data is Panel:
		return

	if data.get("item") == null:
		return

	var tmp = item
	item = data.item
	data.item = tmp

	update_ui()
	data.update_ui()
