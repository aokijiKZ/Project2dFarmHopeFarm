extends Label


func _process(delta: float) -> void:
	text = "%1.2f"%$Timer.time_left if $Timer.time_left > 0 else ""
