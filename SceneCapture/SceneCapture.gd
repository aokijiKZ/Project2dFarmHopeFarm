@tool
extends SubViewport

func capture_scene_texture(scene_path: String)->Texture:
	if load(scene_path) == null:
		printerr("Scene not found")
		return
	var scene_ins = load(scene_path).instantiate()
	scene_ins.process_mode = PROCESS_MODE_DISABLED
	scene_ins.position = Vector2(256,256)
	scene_ins.scale = Vector2(2,2)
	add_child(scene_ins)
	await RenderingServer.frame_post_draw
	var image = get_texture().get_image()
	var texture = ImageTexture.create_from_image(image)
	scene_ins.queue_free()

	return texture

func capture_scene_to_file(scene_path: String, file_path: String):
	var texture = await capture_scene_texture(scene_path)
	if texture == null:
		return
	var image = texture.get_data()
	image.save_png(file_path)