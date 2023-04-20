extends Control

@export var setting_scene :PackedScene
@export var start_scene :PackedScene

@export_file('*.tscn') var dialog_scene_path :String
@export_file('*.dtl') var dialogic_timeline_path :String

func _ready():
	check_dialog()

func check_dialog():
	if GameManager.is_first_time_open_game == true:
		GameManager.is_first_time_open_game = false
		
		var dialog_scene_res = load(dialog_scene_path)
		if dialog_scene_res == null:
			printerr("dialog_scene_path: " + dialog_scene_path + " is null")
			return
		var dialog_scene = dialog_scene_res.instantiate()
		dialog_scene.dialogic_timeline_path = dialogic_timeline_path
		
		get_parent().call_deferred("add_child", dialog_scene)

func _on_start_button_after_play_press_sound():
	SceneChanger.change_scene_with_package_scene(start_scene)

func _on_setting_button_after_play_press_sound():
	SceneChanger.change_scene_with_package_scene(setting_scene)

func _on_exit_button_after_play_press_sound():
	get_tree().quit()
