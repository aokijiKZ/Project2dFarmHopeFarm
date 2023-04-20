extends Node2D

var item_data :Dictionary
var grow_state_timer :Timer

@export_file('*.tscn') var farm_plot_path :String

@export_file('*.tscn') var water_menu_path :String

@export_file('*.tscn') var harvest_menu_path :String

var state := STATE.STATE_IDLE :
	set(value):
		state = value
		$FarmerAndMouseDectector.force_update()
enum STATE{
	STATE_IDLE,
	STATE_GROWING,
	STATE_READY_TO_HARVEST
}

var frame = 0

func _ready():
	add_seed_texture()
	
func add_seed_texture():
	print("add seed texture")
	if item_data == null:
		return
	
	if item_data.get('type','') != "seed":
		printerr("Error: item_data is not seed")
		return
	
	$AnimatedSprite2D.sprite_frames.clear_all()
	$AnimatedSprite2D.sprite_frames.add_animation("idle")
	var seed_texures = GameDatabase.get_imgs('item',item_data.get('name',''),"")
	print("seed_texures: ",seed_texures)
	$AnimatedSprite2D.sprite_frames.add_frame("idle", seed_texures[0])
	$AnimatedSprite2D.sprite_frames.add_animation("grow")
	for texture in seed_texures.slice(1,-1):
		$AnimatedSprite2D.sprite_frames.add_frame("grow", texture)
	$AnimatedSprite2D.animation = "idle"
	$AnimatedSprite2D.frame = 0

func _on_farmer_and_mouse_dectector_farmer_and_mouse_in_area():
	if state != STATE.STATE_IDLE and state != STATE.STATE_READY_TO_HARVEST:
		return
	GlobalShader.add_outline_shader_to_node($AnimatedSprite2D)

func _on_farmer_and_mouse_dectector_farmer_and_mouse_not_in_area():
	GlobalShader.remove_shader_from_node($AnimatedSprite2D)

func _on_farmer_and_mouse_dectector_left_mouse_clicked_while_farmer_and_mouse_in_area():
	if state == STATE.STATE_IDLE:
		print("not ready to harvest")
		if load(water_menu_path)==null:
			printerr("water menu path is null")
			return
		var water_menu = load(water_menu_path).instantiate()
		var ui = get_tree().root.find_child("UI",true,false)
		if ui == null:
			printerr("Error: UI node not found")
			return
		ui.add_child(water_menu)
		water_menu.completed_interact.connect(_on_water_menu_completed_interact)

	elif state == STATE.STATE_READY_TO_HARVEST:
		var havest_menu_res = load(harvest_menu_path)
		if havest_menu_res == null:
			printerr("Error: havest_menu_res is null")
			return
		var havest_menu = havest_menu_res.instantiate()
		var ui = get_tree().root.find_child("UI",true,false)
		if ui == null:
			printerr("Error: UI node not found")
			return
		ui.add_child(havest_menu)
		havest_menu.completed_interact.connect(_on_harvest_menu_completed_interact)

		

func _on_water_menu_completed_interact():
	state = STATE.STATE_GROWING
	if item_data.get('type','') != "seed":
		printerr("Error: item_data is not seed")
		return
	
	var grow_time_sec = item_data.get('growth_time_sec',0)
	var seed_texures = GameDatabase.get_imgs('item',item_data.get('name',''),"")

	$AnimatedSprite2D.position = Vector2(0,-4)
	$AnimatedSprite2D.animation = "grow"
	$AnimatedSprite2D.frame = 0
	grow_state_timer = Timer.new()
	grow_state_timer.timeout.connect(_on_grow_state_timer_timeout)
	grow_state_timer.wait_time = float(grow_time_sec) / float(seed_texures.size()-1) if seed_texures.size()-1 > 0 else 0
	add_child(grow_state_timer)
	grow_state_timer.start()
	
	$z_index_5/display_grow_time/Display_Timer.start(grow_time_sec)

func _on_grow_state_timer_timeout():
	print("grow_state_timer timeout")

	if item_data.get('type','') != "seed":
		printerr("Error: item_data is not seed")
		return
	var grow_time_sec = item_data.get('growth_time_sec',0)
	var seed_texures = GameDatabase.get_imgs('item',item_data.get('name',''),"")
	var oxygen_generated_point = item_data.get('oxygen_generated_point',0)
	if frame+1 >seed_texures.size()-1:
		grow_state_timer.stop()
		var game = get_tree().root.find_child("Game", true, false)
		if game == null:
			printerr("Error: Game node not found")
			return
		game.oxygen = game.oxygen + oxygen_generated_point
		$FarmerAndMouseDectector.force_update()
		state = STATE.STATE_READY_TO_HARVEST
		$FarmerAndMouseDectector.force_update()
		return
	frame = frame+1
	$AnimatedSprite2D.frame = $AnimatedSprite2D.frame+1


func _on_harvest_menu_completed_interact():
	var game = get_tree().root.find_child("Game", true, false)
	if game == null:
		printerr("Error: Game node not found")
		return
	var inventory = game.inventory
	if item_data.get('type','') != "seed":
		printerr("Error: item_data is not seed")
		return
	var product_name = item_data.get('product_name','')
	# var product_item_data = GameDatabase.get_data('item',product_name)
	inventory.add(product_name)
	
	if load(farm_plot_path)==null:
		printerr("farm plot path is null")
		return
	
	var farm_plot = load(farm_plot_path).instantiate()
	farm_plot.position = position
	farm_plot.state = farm_plot.STATE.COOLDOWN
	get_parent().add_child(farm_plot,true)
	queue_free()