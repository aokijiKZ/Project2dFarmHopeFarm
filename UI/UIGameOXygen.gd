extends TextureProgressBar

var game = null

func _process(delta: float) -> void:
	if game == null:
		game = get_tree().root.find_child("Game", true, false)
		if game != null:
			game.oxygen_changed.connect(update)
			update()

func update():
	$value.text = "%d/%d" %[game.oxygen, game.target_oxygen]
