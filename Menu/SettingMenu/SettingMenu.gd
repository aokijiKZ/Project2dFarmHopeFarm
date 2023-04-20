extends Control

@export_file('*.tscn') var to_scene_when_exit_path:String

func _ready():
	var stream = $AudioStreamPlayer.stream
	$AudioStreamPlayer.stream = null
	$MusicHSlider.value = Setting.get_music_volume()
	$EffectHSlider.value = Setting.get_effect_volume()
	$DialogHSlider.value = Setting.get_dialog_volume()
	_on_music_h_slider_value_changed(Setting.get_music_volume())
	_on_effect_h_slider_value_changed(Setting.get_effect_volume())
	_on_dialog_h_slider_value_changed(Setting.get_dialog_volume())
	
	$AudioStreamPlayer.stream = stream

func _on_exit_menu_button_after_play_press_sound():
	Setting.save()
	SceneChanger.back_to_prev_scene()
	# if to_scene_when_exit_path != "":
	# 	SceneChanger.change_scene_with_path(to_scene_when_exit_path)
	# else:
	# 	hide()
	# 	queue_free()

func _on_music_h_slider_value_changed(value:float):
	Setting.set_music_volume(value)
	$MusicHSlider/Label.text = str(value)
	$AudioStreamPlayer.set_volume_db(Setting.scale_percent_to_volume_db(value))
	$AudioStreamPlayer.play()


func _on_effect_h_slider_value_changed(value:float):
	Setting.set_effect_volume(value)
	$EffectHSlider/Label.text = str(value)
	$AudioStreamPlayer.set_volume_db(Setting.scale_percent_to_volume_db(value))
	$AudioStreamPlayer.play()

func _on_dialog_h_slider_value_changed(value:float):
	Setting.set_dialog_volume(value)
	$DialogHSlider/Label.text = str(value)
	$AudioStreamPlayer.set_volume_db(Setting.scale_percent_to_volume_db(value))
	$AudioStreamPlayer.play()
