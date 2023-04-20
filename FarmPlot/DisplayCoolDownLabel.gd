extends Label


func _process(delta):
	text = "%1.2f"%$CoolDownTimer.time_left if $CoolDownTimer.time_left > 0 else ""
