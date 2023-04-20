extends Node2D

var item_name: String 
var item_quantity:int
var wait_time: float = 0

func _ready() -> void:
	visible = false
	$HBoxContainer/TextureRect.texture = GameDatabase.get_img('item', item_name, 'icon')
	$HBoxContainer/Label.text = "X "+str(item_quantity)
	await get_tree().create_timer(wait_time).timeout
	visible = true
	$AnimationPlayer.play("fly")