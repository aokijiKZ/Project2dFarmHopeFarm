extends Control

var card_paths :Array
@export_file('*.tscn') var card_button_path :String
@export_file('*.tscn') var text_desc_menu_path :String
@export var tutorial_title_text :String
@export_multiline var tutorial_content_text :String

@export_file('*.tscn') var dialog_scene_path :String
@export_file('*.dtl') var dialogic_timeline_path :String


@export var all_card :Array[PackedScene]

func _ready():
	check_dialog()
	GameManager.current_card_path_changed.connect(_on_current_card_path_changed)
	_on_current_card_path_changed()

	card_paths = FileManager.get_files_in_dir("res://Card", "tscn",['Card.tscn'], true)
	if load(card_button_path) == null:
		printerr("Card button not found")
		return
	for c in all_card:
		var card_path = c.resource_path
		var card_button = load(card_button_path).instantiate()
		card_button.card_path = card_path
		print(card_path)
		print(GameManager.unlocked_cards_path)
		print(GameManager.unlocked_cards_path.has(card_path))
		if not GameManager.unlocked_cards_path.has(card_path):
			card_button.disabled = true
		$AllCardBG/ScrollContainer/HBoxContainer.add_child(card_button)
	print(card_paths)

func check_dialog():
	if GameManager.is_first_time_recive_card == true:
		GameManager.is_first_time_recive_card = false
		
		var dialog_scene_res = load(dialog_scene_path)
		if dialog_scene_res == null:
			printerr("dialog_scene_path: " + dialog_scene_path + " is null")
			return
		var dialog_scene = dialog_scene_res.instantiate()
		dialog_scene.dialogic_timeline_path = dialogic_timeline_path
		get_parent().add_child(dialog_scene)

func _on_current_card_path_changed():
	if GameManager.current_card_path == "":
		$SelectCard/card_pic.texture = null
		$bg_detail/bg_desc/DescText.text = ""
		$bg_detail/bg_buff/BuffText.text = ""
		return
	if load(GameManager.current_card_path) == null:
		printerr("Card not found")
		return
	var card_ins = load(GameManager.current_card_path).instantiate()
	$SelectCard/card_pic.texture = card_ins.pic
	$bg_detail/bg_desc/DescText.text = card_ins.desc
	$bg_detail/bg_buff/BuffText.text = card_ins.get_buff_info()
	card_ins.queue_free()

func _on_select_card_after_play_press_sound() -> void:
	GameManager.current_card_path = ""
	print("selected card path: " + GameManager.current_card_path)
	
func _on_exit_menu_button_after_play_press_sound() -> void:
	hide()
	queue_free()


func _on_tutorial_button_after_play_press_sound() -> void:
	if load(text_desc_menu_path) == null:
		printerr("TextDescMenu not found")
		return
	var text_desc_menu = load(text_desc_menu_path).instantiate()
	text_desc_menu.title_text = tutorial_title_text
	text_desc_menu.content_text = tutorial_content_text
	add_child(text_desc_menu,true)
