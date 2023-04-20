extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$AnimatedSprite2D.speed_scale = randf_range(0.1, 0.5)
