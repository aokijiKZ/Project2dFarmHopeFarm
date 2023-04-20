extends Control

var farmer
var game
var shop:Shop

@export_file('*.tscn') var buy_slot_path:String
@export_file('*.tscn') var sell_slot_path:String
@export_file('*.tscn') var order_slot_path:String
@export_file('*.tscn') var air_drop_path:String

@export_file('*.tscn') var dialog_scene_path :String
@export_file('*.dtl') var dialogic_timeline_path :String

func _ready() -> void:
	check_dialog()

	farmer = get_tree().root.find_child("Farmer", true, false)
	if farmer == null:
		printerr("Farmer not found")
		return
	farmer.can_move = false

	var ui_inventory = get_tree().root.find_child("UIInventory", true, false)
	if ui_inventory == null:
		printerr("UIInventory not found")
	ui_inventory.close()

	game = get_tree().root.find_child("Game", true, false)
	if game == null:
		printerr("Game not found")
	shop = Shop.new()
	shop.setup(game.shop_items_for_sale,game.inventory, game.money)
	shop.order_inventory.items_changed.connect(update_order)
	shop.player_inventory.items_changed.connect(update_sell)
	game.money.amount_changed.connect(update_money)
	update_buy()
	update_order()
	update_sell()
	update_money()


func check_dialog():
	if GameManager.is_first_time_in_shop == true:
		GameManager.is_first_time_in_shop = false
		
		var dialog_scene_res = load(dialog_scene_path)
		if dialog_scene_res == null:
			printerr("dialog_scene_path: " + dialog_scene_path + " is null")
			return
		var dialog_scene = dialog_scene_res.instantiate()
		dialog_scene.dialogic_timeline_path = dialogic_timeline_path
		get_parent().add_child(dialog_scene)

func update_buy() -> void:
	#clear
	for c in $BuyScrollContainer/VBoxContainer.get_children():
		c.queue_free()
	
	#add
	var buy_slot_res = load(buy_slot_path)
	if buy_slot_res == null:
		printerr("Buy slot not found")
		return
	
	for item_name in shop.items_for_sale:
		var item_data = GameDatabase.get_data('item',item_name)
		var buy_slot_ins = buy_slot_res.instantiate()
		buy_slot_ins.get_child(0).after_play_press_sound.connect(on_item_add_to_order.bind(item_name))
		buy_slot_ins.get_child(1).texture = GameDatabase.get_img('item',item_name,'icon')
		buy_slot_ins.get_child(2).text = ''
		buy_slot_ins.get_child(3).text = item_data.get('display_name','')
		buy_slot_ins.get_child(4).text = str(item_data.get('buy_price',0)) + " ทอง"
		buy_slot_ins.tooltip_text = item_data.get('desc','')
		$BuyScrollContainer/VBoxContainer.add_child(buy_slot_ins,true)
		

func update_sell():
	#clear
	for c in $SellScrollContainer/VBoxContainer.get_children():
		c.queue_free()
	
	#add
	var sell_slot_res = load(sell_slot_path)
	if sell_slot_res == null:
		printerr("Sell slot not found")
		return
	
	for item_name in shop.player_inventory.get_item_names():
		var item_data = GameDatabase.get_data('item',item_name)
		var sell_price = item_data.get('sell_price',0)
		if sell_price <= 0:
			continue
		var sell_slot_ins = sell_slot_res.instantiate()
		sell_slot_ins.get_child(0).after_play_press_sound.connect(on_item_sell.bind(item_name))
		sell_slot_ins.get_child(1).texture = GameDatabase.get_img('item',item_name,'icon')
		sell_slot_ins.get_child(2).text = str(shop.player_inventory.get_item_quantity(item_name))
		sell_slot_ins.get_child(3).text = item_data.get('display_name','')
		sell_slot_ins.get_child(4).text = str(sell_price)+ " ทอง"
		sell_slot_ins.tooltip_text = item_data.get('desc','')
		$SellScrollContainer/VBoxContainer.add_child(sell_slot_ins,true)

func update_order():
	#clear
	for c in $OrderScrollContainer/VBoxContainer.get_children():
		c.queue_free()
	
	#add
	var order_slot_res = load(order_slot_path)
	if order_slot_res == null:
		printerr("Order slot not found")
		return
	
	for item_name in shop.order_inventory.get_item_names():
		var item_data = GameDatabase.get_data('item',item_name)
		var order_slot_ins = order_slot_res.instantiate()
		order_slot_ins.get_child(0).after_play_press_sound.connect(on_item_remove_from_order.bind(item_name))
		order_slot_ins.get_child(1).texture = GameDatabase.get_img('item',item_name,'icon')
		order_slot_ins.get_child(2).text = str(shop.order_inventory.get_item_quantity(item_name))
		order_slot_ins.get_child(3).text = item_data.get('display_name','')
		order_slot_ins.tooltip_text = item_data.get('desc','')

		$OrderScrollContainer/VBoxContainer.add_child(order_slot_ins,true)

func update_money():
	$Money.text = str(game.money.amount)

func on_item_add_to_order(item_name:String) -> void:
	shop.add_item_to_order(item_name)

func on_item_remove_from_order(item_name:String) -> void:
	shop.remove_item_from_order(item_name)

func on_item_sell(item_name:String) -> void:
	shop.sell_item(item_name)

func on_sell_all() -> void:
	shop.sell_items()

func on_clear_order() -> void:
	shop.clear_order()

func on_confirm_order() -> void:
	var order_inventory = shop.confirm_order()
	print("confirm order ",order_inventory)
	if order_inventory.get_size() == 0:
		return
	
	$confirmButton.disabled = true

	var aridropstation = get_tree().root.find_child("AriDropStation", true, false)
	if aridropstation == null:
		printerr("AriDropStation not found")
		return

	var air_drop_res = load(air_drop_path)
	if air_drop_res == null:
		printerr("Air drop not found")
		return
	var air_drop_ins = air_drop_res.instantiate()
	air_drop_ins.order_inventory = order_inventory
	air_drop_ins.position = aridropstation.position
	aridropstation.get_parent().add_child(air_drop_ins)

	hide()
	queue_free()
	

func _on_exit_menu_button_after_play_press_sound() -> void:
	hide()
	shop.clear_order()
	queue_free()

func _exit_tree() -> void:
	if farmer == null:
		printerr("Farmer not found")
		return
	farmer.can_move = true


