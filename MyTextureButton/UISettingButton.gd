extends "res://MyTextureButton/MyTextureButton.gd"

@export_file('*.tscn') var pause_menu_path :String

func _on_after_play_press_sound() -> void:
	if load(pause_menu_path) == null:
		printerr("Pause menu scene not found")
		return
	var pase_menu_ins = load(pause_menu_path).instantiate()
	
	var ui = get_tree().root.find_child("UI", true, false)
	if ui == null:
		printerr("UI node not found")
		return
	
	ui.add_child(pase_menu_ins)
	
