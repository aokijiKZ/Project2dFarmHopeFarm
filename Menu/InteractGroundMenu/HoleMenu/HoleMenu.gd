extends "res://Menu/InteractGroundMenu/InteractGroundMenu.gd"

@export var bg_hole_grounds :Array[Texture]

signal count_changed

func _ready() -> void:
	super._ready()

var max_count :int = 3
var count := 0 :
	set(value):
		count = value
		emit_signal("count_changed")

func _on_hole_button_mouse_entered() -> void:
	GlobalShader.add_outline_shader_to_node($HoleButton)

func _on_hole_button_mouse_exited() -> void:
	GlobalShader.remove_shader_from_node($HoleButton)

func _on_hole_button_after_play_press_sound() -> void:
	count = count + 1
	var farmer = get_tree().root.find_child("Farmer", true, false)
	if farmer == null:
		printerr("Farmer not found")
		return
	if farmer.stamina <= 0:
		farmer.talk('เหนื่อย! [พลังงานหมดแล้ว]')
		hide()
		queue_free()
	farmer.stamina = farmer.stamina - 1
	check_count()

func check_count():
	if count == max_count:
		emit_signal("completed_interact")
		hide()
		queue_free()

func _on_count_changed() -> void:
	if bg_hole_grounds.size() > 0:
		var index := bg_hole_grounds.size() / max_count * count
		if index >= 0 and index < bg_hole_grounds.size():
			$Bg/groundBg.texture = bg_hole_grounds[index]
