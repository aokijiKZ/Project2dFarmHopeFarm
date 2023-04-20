extends Control

@export var level_path: String
@export var level_img : Texture 


@export var continent_number: int = -1
@export var area_number: int = -1

func _ready():
	update()
	
	
func _on_exit_menu_button_after_play_press_sound():
	hide()
	queue_free()
	
func _on_play_button_after_play_press_sound():
	if load(level_path) == null:
		printerr("level_path is null")
		return
	SceneChanger.change_scene_with_path(level_path)

func _on_swap_section_button_after_play_press_sound():
	$Section1.visible = !$Section1.visible
	$Section2.visible = !$Section2.visible

func update():
	$bg_pic/level_preview.texture = level_img

	var level_data = FileManager.load(level_path+'.data')
	if level_data == null:
		printerr("Level data not found")
		return

	$TitleLabel.text = "ทวีป " + str(continent_number+1) + " พื้นที่ " + str(area_number+1)
	$Section1/bg/Label.text = 'เป้าหมาย ปลูกผัก\nทำออกซิเจนให้ถึง %d หน่วย\nภายในระยะเวลา %d วินาที' %[level_data.target_oxygen, level_data.target_time] 
	$SwapSectionButton.visible = GameManager.is_has_stat(level_path)
	$Section2/bg_text_1/Label1.text = 'เวลากำหนด      %d   นาที'%level_data.target_time
	$Section2/bg_text_2/Label2.text = 'เวลาที่เคยทำได้   %d   นาที'%GameManager.get_used_time(level_path)
	$Section2/bg_text_3/Label3.text = 'ออกซิเจนที่ได้รับ  %d   หน่วย'%GameManager.get_received_oxygen(level_path)
	$Section2/bg_text_4/Label4.text = 'ความสำเร็จ      %d%%   เปอร์เซ็น'%GameManager.get_complate_percent(level_path)
	
	if level_data.get('reward_card_path',"") != "":
		var card_path = level_data.reward_card_path
		var card_res = load(card_path)
		if card_res == null:
			printerr("Card res not found")
			return
		var card = card_res.instantiate()
		$card_text.text = 'รางวัลหากสำเร็จ 100% จะได้รับการ์ด '+card.card_name
	else:
		$card_text.text = ''