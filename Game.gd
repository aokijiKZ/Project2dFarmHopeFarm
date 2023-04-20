extends Node2D

var oxygen := 0 :
	set(value):
		oxygen = clampi(value, 0, target_oxygen)
		emit_signal("oxygen_changed")
@export var target_oxygen := 100
@export var money :Currency = Currency.new()
@export var target_time := 60
@export_file('*.tscn') var next_level_path :String
@export var unlock_oxygen := 0
@export var inventory :Inventory
@export var shop_items_for_sale :Array[String] = []
@export_file('*.tscn') var reward_card_path :String

@export_file('*.tscn') var end_game_menu_path :String

@export_file('*.tscn') var dialog_scene_path :String
@export_file('*.dtl') var dialogic_timeline_path :String
	

signal oxygen_changed()

func _ready() -> void:
	check_dialog()
	inventory = inventory.duplicate(true) if inventory != null else Inventory.new()
	shop_items_for_sale = shop_items_for_sale.duplicate(true) if shop_items_for_sale != null else []
	money = money.duplicate(true) if money != null else Currency.new()
	oxygen_changed.connect(_on_oxygen_changed)
	check_card_buff()

func check_dialog():
	if GameManager.is_first_time_in_game == true:
		GameManager.is_first_time_in_game = false
		
		var dialog_scene_res = load(dialog_scene_path)
		if dialog_scene_res == null:
			printerr("dialog_scene_path: " + dialog_scene_path + " is null")
			return
		var dialog_scene = dialog_scene_res.instantiate()
		dialog_scene.dialogic_timeline_path = dialogic_timeline_path
		get_parent().add_child(dialog_scene)

func _on_oxygen_changed() -> void:
	
	if oxygen >= target_oxygen:
		var ui = get_tree().root.find_child("UI", true, false)
		if ui == null:
			printerr("Could not find UI")
			return
		
		var end_game_menu_res = load(end_game_menu_path)
		if end_game_menu_res == null:
			printerr("Could not load end game menu")
			return
		
		var end_game_menu_ins = end_game_menu_res.instantiate()
		ui.add_child(end_game_menu_ins)

func check_card_buff():
	if GameManager.current_card_path == "":
		print("No card to buff")
		return
	var card_res = load(GameManager.current_card_path)
	if card_res == null:
		printerr("Could not load card")
		return
	var card_ins = card_res.instantiate()

	var farmer = get_tree().root.find_child("Farmer", true, false)
	if farmer == null:
		printerr("Could not find farmer")
		return
	
	farmer.max_stamina = farmer.max_stamina + card_ins.buff_energy
	farmer.speed = farmer.speed + card_ins.buff_move_speed


	for item_name in card_ins.buff_start_item_names:
		inventory.add_item(item_name)


