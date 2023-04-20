@tool
extends Node2D

@export var regenerate : bool = false:
	set(value):
		if value:
			regenerate = false
			generate()

func generate():
	var all_level_files = FileManager.get_files_in_dir("res://Level/", ".tscn",['PreGenerateImgAndLevelStat.tscn'])	
	print(all_level_files)
	
	for level_file in all_level_files:
		capture_scene_to_file(level_file, level_file+".png")
		get_level_stat(level_file, level_file+".data")
		await get_tree().create_timer(0.1).timeout

func capture_scene_to_file(scene_path: String,file_path:String):
	if load(scene_path) == null:
		printerr("Scene not found")
		return
	var scene_ins = load(scene_path).instantiate()
	scene_ins.process_mode = PROCESS_MODE_DISABLED
	scene_ins.position = Vector2(256,256)
	scene_ins.scale = Vector2(2,2)
	scene_ins.get_node('UI').visible = false
	$SubViewport.add_child(scene_ins)
	scene_ins.owner = get_tree().edited_scene_root
	await RenderingServer.frame_post_draw
	var image = $SubViewport.get_texture().get_image()
	if image.save_png(file_path) == OK:
		scene_ins.queue_free()

func get_level_stat(scene_path: String,file_path:String):
	if load(scene_path) == null:
		printerr("Scene not found")
		return
	var scene_ins = load(scene_path).instantiate()
	var data = {
		"target_oxygen": scene_ins.target_oxygen,
		"target_time": scene_ins.target_time,
		"unlock_oxygen": scene_ins.unlock_oxygen,
		"reward_card_path": scene_ins.reward_card_path,
	}
	FileManager.save(file_path,data)