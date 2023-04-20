extends TextureRect

var game = null

func _process(delta: float) -> void:
	if game == null:
		game = get_tree().root.find_child("Game", true, false)
		if game != null:
			game.money.amount_changed.connect(update)
			update()

func update():
	$value.text = "%4d ทอง" %[game.money.amount]
