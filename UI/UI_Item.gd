extends TextureRect

var inventory

func _get_drag_data(at_position):
	var slot_index = get_parent().get_index()

	if inventory.get_child(slot_index).get_child_count() == 0:
		return {}

	var data = {
		'slot_index':slot_index,
	}

	var control = Control.new()
	var texturerect = TextureRect.new()
	texturerect.texture = texture
	texturerect.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	texturerect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	texturerect.size = texturerect.texture.get_size()
	texturerect.position = -0.5 * texturerect.size
	texturerect.self_modulate = Color(1,1,1,0.5)
	control.add_child(texturerect)
	set_drag_preview(control)
	return data

func _can_drop_data(position, data):
	return typeof(data) == TYPE_DICTIONARY and (data.has("slot_index") or data.has("item"))

func _drop_data(position, data):
	if data.has("slot_index"):
		var slot_index1 = data.slot_index
		var slot_index2 = get_parent().get_index()
		inventory.swap_or_stack_item(slot_index1, slot_index2)
	elif data.has("item"):
		var item1 = data.item
		var slot_index2 = get_parent().get_index()
		var slot2 = inventory.get_child(slot_index2)
		var item2 = slot2.get_child(0) if slot2.get_child_count() > 0 else null
		if item2 != null and item2.is_equipable==false:
			return
		for i in slot2.get_children():
			inventory.remove_item_with_slot_index(slot_index2)
		inventory.add_item_with_slot_index(item1, slot_index2)
		inventory.get_parent().equipped_item = item2
