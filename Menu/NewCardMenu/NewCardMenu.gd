extends Control

@export_file('*.tscn') var card_path : String

func _ready() -> void:
	update()

func update() -> void:
	var card_res
	for c in GameDatabase.cards:
		if c.resource_path == card_path:
			card_res = c
		
	if card_res == null:
		printerr("Card path is invalid")
		return
	var card_ins = card_res.instantiate()

	$CardNameLabel.text = card_ins.card_name
	$CardDescLabel.text = card_ins.desc + "\n\n" + card_ins.get_buff_info()
	$CardPic.texture = card_ins.pic

	GameManager.unlocked_cards_path.append(card_path)

func _on_exit_menu_button_after_play_press_sound() -> void:
	hide()
	queue_free()

