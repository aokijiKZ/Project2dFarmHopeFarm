extends StaticBody2D

@export_file('*.tscn') var shop_menu_path:String

func _on_farmer_and_mouse_dectector_farmer_and_mouse_in_area() -> void:
	var air_drop = get_tree().root.find_child("AirDrop", true, false)
	if air_drop != null:
		return
	GlobalShader.add_outline_shader_to_node($Sprite2D)


func _on_farmer_and_mouse_dectector_farmer_and_mouse_not_in_area() -> void:
	GlobalShader.remove_shader_from_node($Sprite2D)

func _on_farmer_and_mouse_dectector_left_mouse_clicked_while_farmer_and_mouse_in_area() -> void:
	var air_drop = get_tree().root.find_child("AirDrop", true, false)
	if air_drop != null:
		return
	
	var shop_menu_res = load(shop_menu_path)
	if shop_menu_res == null:
		print("Error: Could not load shop menu scene")
		return
	var shop_menu_ins = shop_menu_res.instantiate()
	var ui = get_tree().root.find_child("UI", true, false)
	if ui == null:
		print("Error: Could not find UI node")
		return
	ui.add_child(shop_menu_ins,true)


	
	
