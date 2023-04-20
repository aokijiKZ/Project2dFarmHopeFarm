extends Control

var state:= State.OPEN
enum State {
	OPEN,
	CLOSED
}

func _on_close_button_after_play_press_sound() -> void:
	close()

func _on_open_button_after_play_press_sound() -> void:
	open()

func close() -> void:
	if state == State.OPEN:
		$AnimationPlayer.play("close")
		await $AnimationPlayer.animation_finished
		state = State.CLOSED

func open() -> void:
	if state == State.CLOSED:
		$AnimationPlayer.play_backwards("close")
		await $AnimationPlayer.animation_finished
		state = State.OPEN
