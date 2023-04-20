extends TextureRect

signal seed_recived(item_data)

func _can_drop_data(at_position: Vector2, data) -> bool:
	return data is Dictionary and data.has("item_data")

func _drop_data(at_position: Vector2, data):
	var item_data = data["item_data"]
	texture = GameDatabase.get_img('item',item_data.get('name'),'icon')
	emit_signal("seed_recived",item_data)
