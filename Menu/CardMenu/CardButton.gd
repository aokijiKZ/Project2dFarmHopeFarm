extends "res://MyTextureButton/MyTextureButton.gd"

@export_file('*.tscn') var text_desc_menu_path :String
@export_file('*.tscn') var card_path :String

func _ready() -> void:
	super._ready()

	if load(card_path)==null:
		printerr("card_path is null")
		return

	var card_ins = load(card_path).instantiate()
	texture_normal = card_ins.pic 
	texture_pressed = card_ins.pic
	texture_hover = card_ins.pic
	texture_disabled = card_ins.pic
	
	if disabled:
		disabled_effect()

func _on_after_play_press_sound() -> void:
	if load(text_desc_menu_path)==null:
		printerr("text_desc_menu_path is null")
		return
	var text_desc_menu_ins = load(text_desc_menu_path).instantiate()
	if load(card_path)==null:
		printerr("card_path is null")
		return
	var card_ins = load(card_path).instantiate()
	text_desc_menu_ins.title_text = card_ins.card_name
	text_desc_menu_ins.content_text = card_ins.desc
	get_tree().root.get_child(-1).add_child(text_desc_menu_ins)

func hover_effect() -> void:
	GlobalShader.add_outline_shader_to_node(self,Color(1,1,1,1))

func remove_hover_effect() -> void:
	GlobalShader.remove_shader_from_node(self)

func disabled_effect() -> void:
	self_modulate = Color(0.5,0.5,0.5,1)


func _get_drag_data(at_position: Vector2):
	if load(card_path)==null:
		printerr("card_path is null")
		return
	if disabled == true:
		return

	var drag_data = {}
	drag_data["card_path"] = card_path
	
	var control = Control.new()
	control.z_index = 2
	var texturerect = TextureRect.new()
	texturerect.texture = texture_normal
	texturerect.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	texturerect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	texturerect.size = texturerect.texture.get_size()
	texturerect.position = -0.5 * texturerect.size
	texturerect.self_modulate = Color(1,1,1,0.5)
	control.add_child(texturerect)
	set_drag_preview(control)

	return drag_data
