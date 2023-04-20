extends Control

@export var end_game_sound : AudioStream
@export_file("*.tscn") var level_select_menu_path : String
@export_file('*.tscn') var new_card_menu_path : String

func _ready() -> void:
	var game = get_tree().root.find_child("Game",true,false)
	if game == null:
		printerr("game is null")
		return
	game.process_mode = Node.PROCESS_MODE_DISABLED
	SoundManager.play_sfx(end_game_sound)
	update()

func update():
	var game = get_tree().root.find_child("Game",true,false)
	if game == null:
		printerr("game is null")
		return
	var game_timer = get_tree().root.find_child("GameTimer",true,false)

	var target_oxygen = game.target_oxygen
	var target_time_sec = game.target_time
	var use_time_sec = game_timer.current_second

	var oxygen_ratio:float

	if use_time_sec <= target_time_sec:
		oxygen_ratio = 1.0
	elif use_time_sec > target_time_sec and use_time_sec < 2.0*target_time_sec:
		oxygen_ratio = (2.0*target_time_sec-use_time_sec)/target_time_sec
	else:
		oxygen_ratio = 0.0
	var recive_oxygen = target_oxygen * oxygen_ratio
	var complate_percent = 100* oxygen_ratio

	GameManager.update_stat(game.scene_file_path,use_time_sec,recive_oxygen,complate_percent,complate_percent==100.0)

	if complate_percent >= 100.0:
		check_reward_card()

	$BgDetail1/value.text = "%2.2f"%target_time_sec
	$BgDetail2/value.text = "%2.2f"%use_time_sec
	$BgDetail3/value.text = "%2.2f"%recive_oxygen
	$BgDetail4/value.text = "%2.2f %%"%complate_percent

	if game.next_level_path == "" :
		$NextButton.disabled = true
	else:
		var data = FileManager.load(game.next_level_path+'.data')
		if GameManager.get_total_oxygen() < data.get('unlock_oxygen',0):
			$NextButton.disabled = true

func _on_home_button_after_play_press_sound() -> void:
	SceneChanger.change_scene_with_path(level_select_menu_path)

func _on_re_button_after_play_press_sound() -> void:
	SceneChanger.reload_current_scene()

func _on_next_button_after_play_press_sound() -> void:
	var game = get_tree().root.find_child("Game",true,false)
	if game == null:
		printerr("game is null")
		return
	SceneChanger.change_scene_with_path(game.next_level_path)

func check_reward_card():
	print("check_reward_card")
	var game = get_tree().root.find_child("Game",true,false)
	if game == null:
		printerr("game is null")
		return
	var reward_card_path = game.reward_card_path
	if reward_card_path == "":
		return

	if !GameManager.unlocked_cards_path.has(reward_card_path):
		var new_card_menu_res = load(new_card_menu_path)
		if new_card_menu_res == null:
			printerr("new_card_menu_res is null")
			return
		var new_card_menu = new_card_menu_res.instantiate()
		new_card_menu.card_path = reward_card_path
		var ui = get_tree().root.find_child("UI",true,false)
		if ui == null:
			printerr("ui is null")
			return
		ui.add_child(new_card_menu)