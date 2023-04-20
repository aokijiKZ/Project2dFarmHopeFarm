extends TextureRect

var item_data :Dictionary
var item_quantity :int
var drag_enabled = false

func _ready() -> void:
	update()

func update():
	if item_data == null:
		return
	
	$Icon.texture = GameDatabase.get_img("item",item_data.get("name",""),"icon")
	$section_normal/ItemNameLabel.text = item_data.get("display_name","")
	$section_use/ItemNameLabel.text = item_data.get("display_name","")
	$Quantity.text = str(item_quantity)
	tooltip_text = item_data.get("desc","")
	if item_data.get("type","") == "potion":
		$section_use.visible = true
		$section_normal.visible = false
	else:
		$section_use.visible = false
		$section_normal.visible = true

		
func _on_use_button_after_play_press_sound() -> void:
	var farmer = get_tree().root.find_child("Farmer",true,false)
	if farmer == null:
		printerr("Farmer not found")
		return

	farmer.use_item(item_data)

func _get_drag_data(at_position: Vector2):
	print("get drag data ",item_data)
	if drag_enabled == false:
		return
	if item_data == null:
		printerr("item data is null")
		return

	var drag_data = {}
	drag_data["item_data"] = item_data

	var control = Control.new()
	var texturerect = TextureRect.new()
	texturerect.texture = $Icon.texture
	texturerect.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	texturerect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	texturerect.size = texturerect.texture.get_size()
	texturerect.position = -0.5 * texturerect.size
	texturerect.self_modulate = Color(1,1,1,0.5)
	control.add_child(texturerect)
	set_drag_preview(control)

	return drag_data

