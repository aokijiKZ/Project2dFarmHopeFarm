extends TextureRect

var game_timer = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_timer == null:
		game_timer = get_tree().root.find_child("GameTimer", true, false)
		if game_timer != null:
			print("GameTimer found")
			game_timer.time_changed.connect(update)
			update()

func update():
	var game = get_tree().root.find_child("Game", true, false)
	if game == null:
		printerr("Game not found")
		return
	
	$value.text = "%3d/%d\t วินาที"%[game_timer.current_second,game.target_time]