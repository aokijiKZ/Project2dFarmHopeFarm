extends StaticBody2D

var order_inventory:Inventory

var drop_time = 5.0

@export_file('*.tscn') var floating_item_path :String

func _ready() -> void:
	
	$z_index_5/drop_time_display/Timer.start(drop_time)
	$z_index_5/drop_time_display/Timer.timeout.connect(_on_Timer_timeout)

func _on_Timer_timeout():
	$AnimationPlayer.play("drop")

func _on_farmer_and_mouse_dectector_farmer_and_mouse_in_area() -> void:
	GlobalShader.add_outline_shader_to_node($Sprite2D)

func _on_farmer_and_mouse_dectector_farmer_and_mouse_not_in_area() -> void:
	GlobalShader.remove_shader_from_node($Sprite2D)

func _on_farmer_and_mouse_dectector_left_mouse_clicked_while_farmer_and_mouse_in_area() -> void:	
	var game = get_tree().root.find_child("Game", true, false)
	if game==null:
		printerr("Game not found")
		return
	
	var player_inventory = game.inventory

	player_inventory.merge(order_inventory)

	var ui_inventory = get_tree().root.find_child("UIInventory",true,false)
	if ui_inventory==null:
		printerr("UIInventory not found")
		return
	ui_inventory.open()
	
	var farmer = get_tree().root.find_child("Farmer",true,false)
	if farmer==null:
		printerr("Farmer not found")
		return

	var floating_item_res = load(floating_item_path)
	if floating_item_res==null:
		printerr("FloatingItem not found")
		return
	
	var index = 0
	for item_name in order_inventory.get_item_names():
		var item_quantity = order_inventory.get_item_quantity(item_name)
		var floating_item_ins = floating_item_res.instantiate()
		floating_item_ins.item_name = item_name
		floating_item_ins.item_quantity = item_quantity
		floating_item_ins.wait_time = index * 0.2
		get_parent().add_child(floating_item_ins)
		floating_item_ins.global_position = farmer.global_position
		index = index + 1

	

	
	farmer.force_refesh_area()
	call_deferred("queue_free")
	# queue_free()
