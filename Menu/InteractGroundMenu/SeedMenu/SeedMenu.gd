extends "res://Menu/InteractGroundMenu/InteractGroundMenu.gd"

var farm_plot

@export var seed_sound: AudioStream

func _ready() -> void:
	super._ready()
	update_seed_items()

func update_seed_items():
	pass

func _on_seed_reciver_seed_recived(item_data) -> void:
	SoundManager.play_sfx(seed_sound)
	var game = get_tree().root.find_child("Game", true, false)
	if game == null:
		printerr("Game not found")
		return
	var inventory = game.inventory
	inventory.remove(item_data.get('name'))
	farm_plot.item_data = item_data
	emit_signal("completed_interact")
	hide()
	queue_free()
