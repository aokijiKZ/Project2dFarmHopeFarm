extends "res://MyTextureButton/MyTextureButton.gd"

func _can_drop_data(at_position: Vector2, data) -> bool:
	return data is Dictionary and data.has("card_path")

func _drop_data(at_position: Vector2, data):
	var card_path = data["card_path"]
	GameManager.current_card_path = card_path
	# var card_ins = load(card_path).instantiate()
	# print(card_ins.card_name)
