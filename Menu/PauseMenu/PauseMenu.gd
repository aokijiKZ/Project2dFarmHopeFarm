extends Control

@export_file('*.tscn') var setting_menu_path :String
@export_file('*.tscn') var home_menu_path :String

func _ready() -> void:
	var game = get_tree().root.find_child("Game",true,false)
	if game != null:
		game.process_mode = Node.PROCESS_MODE_DISABLED
	

func _on_exit_button_after_play_press_sound() -> void:
	get_tree().quit()

func _on_setting_button_after_play_press_sound() -> void:
	# var setting_menu = load(setting_menu_path).instantiate()
	SceneChanger.change_scene_with_path(setting_menu_path)

func _on_home_button_after_play_press_sound() -> void:
	SceneChanger.change_scene_with_path(home_menu_path)

func _on_re_button_after_play_press_sound() -> void:
	SceneChanger.reload_current_scene()

func _on_exit_menu_button_after_play_press_sound() -> void:
	hide()
	queue_free()
	var game = get_tree().root.find_child("Game",true,false)
	if game != null:
		game.process_mode = Node.PROCESS_MODE_INHERIT