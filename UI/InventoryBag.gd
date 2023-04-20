extends TextureRect

@export_file('*.tscn') var ui_item_path :String

var game

@export var item_type_filter :String
@export var drag_enabled :bool = false

func _process(delta: float) -> void:
	if game == null:
		game = get_tree().root.find_child("Game", true, false)
		if game != null:
			if game.inventory == null:
				printerr("Inventory is null")
				return
			game.inventory.items_changed.connect(_on_items_changed)
			_on_items_changed()

func _on_items_changed():
	#clear all children
	for c in $ScrollContainer/VBoxContainer.get_children():
		c.queue_free()
	
	#add UIitem
	if load(ui_item_path) == null:
		printerr("UIItem not found")
		return
	
	var ui_item = load(ui_item_path)
	for item_name in game.inventory.get_item_names():
		var item_data := GameDatabase.get_data("item", item_name)
		var item_quantity = game.inventory.get_item_quantity(item_name)
		if item_type_filter != "":
			if item_data.get('type','') != item_type_filter:
				print("item type filter: " + item_type_filter)
				print("item type: " + item_data.get('type',''))
				continue
	
		var ui_item_ins = ui_item.instantiate()
		ui_item_ins.item_data = item_data
		ui_item_ins.item_quantity = item_quantity
		if drag_enabled:
			ui_item_ins.drag_enabled = true
		$ScrollContainer/VBoxContainer.add_child(ui_item_ins)

		
