extends "res://MyTextureButton/MyTextureButton.gd"
@export_file('*.tscn') var level_path :String 
@export_file('*.tscn') var level_detail_path:String 


func _ready() -> void:
	super._ready()
	update()

func update():
	var level_data = FileManager.load(level_path+'.data')
	if level_data == null:
		printerr("Level data not found")
		lock_level()
	else:
		print(level_data)
		$OxygenNeedLabel.text = "ต้องการออกซิเจน\n%d\nเพื่อปลดล็อก"%level_data.unlock_oxygen
		$OxygenGetLabel.text = "%d%%"%GameManager.get_complate_percent(level_path) if GameManager.get_complate_percent(level_path) >0 else ""
		
		if GameManager.get_total_oxygen() >= level_data.unlock_oxygen:
			if load(level_path+".png") == null:
				printerr("Level preview image not found")
				lock_level()
			else:
				$PreviewImage.texture = load(level_path+".png")
		else:
			lock_level()

func lock_level():
	
	$OxygenNeedLabel.visible = true
	$PreviewImage.visible = false
	disabled = true

func _on_after_play_press_sound() -> void:
	var current_scene = get_tree().root.get_child(-1)
	if load(level_detail_path) == null:
		printerr("Level detail scene not found")
		return
	var level_detail_ins = load(level_detail_path).instantiate()
	level_detail_ins.level_path = level_path
	level_detail_ins.level_img = $PreviewImage.texture
	if current_scene.name == "LevelSelectMenu": # this is for the level select scene
		level_detail_ins.continent_number = get_parent().get_parent().get_index()
		level_detail_ins.area_number = get_index()

	current_scene.add_child(level_detail_ins,true)
