extends TextureButton


@export var press_sound:AudioStream
@export var hover_sound:AudioStream

signal after_play_press_sound()

func _ready():
	pass

func _on_pressed():
	SoundManager.play_sfx(press_sound)
	emit_signal("after_play_press_sound")

func _on_mouse_entered():
	if disabled == false:
		SoundManager.play_sfx(hover_sound)

	
