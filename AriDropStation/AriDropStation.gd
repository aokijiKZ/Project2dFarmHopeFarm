extends StaticBody2D

var state :=STATE.NONE :
	set(value):
		if value == STATE.DROPING:
			$AnimationPlayer.play("droping")
		elif value == STATE.NONE:
			$AnimationPlayer.play("default")
		state = value

enum STATE{
	NONE,
	DROPING,
}


func create_air_drop():
	print("create_air_drop")
	pass