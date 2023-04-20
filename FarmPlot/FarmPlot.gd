extends Node2D

@export_file('*.tscn') var crop_path : String

@export_file('*.tscn') var hole_menu_path: String
@export_file('*.tscn') var seed_menu_path: String

var is_hole: bool = false

var crop = null

var item_data:Dictionary

var state := STATE.EMPTY :
	set(value):
		state = value
		$FarmerAndMouseDectector.force_update()
enum STATE {
	EMPTY,
	HOLE,
	COOLDOWN,
}

var cooldown_time_sec = 5

func _ready() -> void:
	if state == STATE.COOLDOWN:
		$z_index_5/DisplayCoolDownLabel/CoolDownTimer.start(cooldown_time_sec)
		$AnimationPlayer.speed_scale = 1.0/cooldown_time_sec
		$AnimationPlayer.play_backwards("hole")


func _on_farmer_and_mouse_dectector_farmer_and_mouse_in_area() -> void:
	if state==STATE.COOLDOWN:
		return
	GlobalShader.add_outline_shader_to_node($Sprite2D)

func _on_farmer_and_mouse_dectector_farmer_and_mouse_not_in_area() -> void:
	GlobalShader.remove_shader_from_node($Sprite2D)

func _on_farmer_and_mouse_dectector_left_mouse_clicked_while_farmer_and_mouse_in_area() -> void:
	if state==STATE.EMPTY:
		if load(hole_menu_path) == null:
			printerr("Error: hole_menu_path is not a valid path")
			return
		
		var ui = get_tree().root.find_child("UI",true,false)
		if ui == null:
			printerr("Error: UI node not found")
			return

		var hole_menu = load(hole_menu_path).instantiate()
		ui.add_child(hole_menu)
		hole_menu.completed_interact.connect(_on_hole_menu_completed_interact)
	elif state==STATE.HOLE:
		if load(seed_menu_path) == null:
			printerr("Error: seed_menu_path is not a valid path")
			return
		
		var ui = get_tree().root.find_child("UI",true,false)
		if ui == null:
			printerr("Error: UI node not found")
			return

		var seed_menu = load(seed_menu_path).instantiate()
		seed_menu.farm_plot = self
		ui.add_child(seed_menu)
		seed_menu.completed_interact.connect(_on_seed_menu_completed_interact)

func _on_hole_menu_completed_interact():
	state = STATE.HOLE
	$AnimationPlayer.speed_scale = 2
	$AnimationPlayer.play("hole")

func _on_seed_menu_completed_interact():
	if load(crop_path) == null:
		printerr("Error: crop_path is not a valid path")
		return
	
	var crop = load(crop_path).instantiate()
	crop.position = position
	crop.item_data = item_data
	get_parent().add_child(crop)
	queue_free()


func _on_cool_down_timer_timeout() -> void:
	state = STATE.EMPTY