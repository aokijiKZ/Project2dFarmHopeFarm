extends Control

@export_file('*.tscn') var card_menu_path : String
@export_file('*.tscn') var title_menu_path : String

@export_file('*.tscn') var dialog_scene_path :String
@export_file('*.dtl') var dialogic_timeline_path :String
@export_file('*.dtl') var dialogic_timeline_end_game_path :String

func _ready():
	check_dialog()
	var total_oxygen = GameManager.get_total_oxygen()
	$OxygenBar.value = Utility.value_to_percent(total_oxygen, get_max_total_oxygen())
	$OxygenBar/Label.text = 'ออกซิเจน %d'%total_oxygen + " / " + str(get_max_total_oxygen())

func check_dialog():
	if GameManager.is_first_time_in_area_selection == true:
		GameManager.is_first_time_in_area_selection = false
		
		var dialog_scene_res = load(dialog_scene_path)
		if dialog_scene_res == null:
			printerr("dialog_scene_path: " + dialog_scene_path + " is null")
			return
		var dialog_scene = dialog_scene_res.instantiate()
		dialog_scene.dialogic_timeline_path = dialogic_timeline_path
		get_parent().add_child(dialog_scene)

	if GameManager.get_total_oxygen() >= get_max_total_oxygen() and GameManager.is_first_time_complate_game == true:
		GameManager.is_first_time_complate_game = false
		
		var dialog_scene_res = load(dialog_scene_path)
		if dialog_scene_res == null:
			printerr("dialog_scene_path: " + dialog_scene_path + " is null")
			return
		var dialog_scene = dialog_scene_res.instantiate()
		dialog_scene.dialogic_timeline_path = dialogic_timeline_end_game_path
		get_parent().add_child(dialog_scene)

func get_max_total_oxygen():
	var max_total_oxygen = 0
	# todo calculate max total oxygen
	for tab in $LevelTabContainer.get_children():
		for level_preview in tab.get_child(0).get_children():
			var level_path = level_preview.level_path
			var level_data = FileManager.load(level_path+'.data')
			if level_data == null:
				printerr("Level data not found")
				continue
			max_total_oxygen = max_total_oxygen+level_data.target_oxygen
	return max_total_oxygen
	
func _on_level_tab_container_tab_changed(tab:int):
	$TabChangeSoundPlayer.play()


func _on_my_texture_button_after_play_press_sound() -> void:
	if load(card_menu_path) == null:
		printerr("card_menu_path: " + card_menu_path + " is null")
		return
	var card_menu = load(card_menu_path).instantiate()
	add_child(card_menu)

func _on_back_button_after_play_press_sound() -> void:
	SceneChanger.change_scene_with_path(title_menu_path)

