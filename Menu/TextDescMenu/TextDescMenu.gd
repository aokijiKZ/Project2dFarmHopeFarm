extends Control

@export var title_text :String
@export var content_text :String

func _ready() -> void:
	$TitleLabel.text = title_text
	$ContentLabel.text = content_text

func _on_my_exit_menu_button_after_play_press_sound() -> void:
	hide()
	queue_free()
