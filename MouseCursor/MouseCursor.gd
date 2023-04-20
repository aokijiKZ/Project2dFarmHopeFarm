extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(preload('res://MouseCursor/new_atlas_texture.tres'),7)
	Input.set_custom_mouse_cursor(preload('res://MouseCursor/new_atlas_texture.tres'),8)
	#7 is Input.CURSOR_CAN_DROP and 8 is Input.CURSOR_FORBIDDEN.