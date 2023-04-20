extends Control


signal completed_interact

var farmer

func _ready() -> void:
	var ui_inventory = get_tree().root.find_child("UIInventory", true, false)
	if ui_inventory == null:
		printerr("UIInventory not found")
		return
	ui_inventory.close()

	farmer = get_tree().root.find_child("Farmer", true, false)
	if farmer == null:
		printerr("Farmer not found")
		return
	farmer.can_move = false



func _on_exit_menu_button_after_play_press_sound() -> void:
	hide()
	queue_free()

func _exit_tree() -> void:
	if farmer == null:
		printerr("Farmer not found")
		return
	farmer.can_move = true
