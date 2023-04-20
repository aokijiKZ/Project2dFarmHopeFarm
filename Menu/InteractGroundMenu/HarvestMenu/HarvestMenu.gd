extends "res://Menu/InteractGroundMenu/InteractGroundMenu.gd"

func _ready() -> void:
	super._ready()

func _on_harvest_button_after_play_press_sound() -> void:
	emit_signal("completed_interact")
	hide()
	queue_free()
