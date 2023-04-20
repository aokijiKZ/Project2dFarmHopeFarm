extends Label


func _process(delta):
	text = "%.2f"%$Display_Timer.time_left if $Display_Timer.time_left > 0 else ""
	
