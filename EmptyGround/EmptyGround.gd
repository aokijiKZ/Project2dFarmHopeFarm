extends Node2D

@export var farm_plot_packageScene : PackedScene

func _on_hole_hurt_box_area_entered(area:Area2D):
	
	if farm_plot_packageScene != null:
		var farm_plot_ins = farm_plot_packageScene.instantiate()
		farm_plot_ins.position = position
		get_parent().call_deferred("add_child", farm_plot_ins)
		queue_free()


