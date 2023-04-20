extends Node2D

var is_farmer_in_area := false
var is_mouse_in_area := false

signal farmer_and_mouse_in_area()
signal farmer_and_mouse_not_in_area()
signal left_mouse_clicked_while_farmer_and_mouse_in_area()


func _on_farmer_hit_box_area_entered(area:Area2D):
	is_farmer_in_area = true
	
	check_farmer_in_area_and_mouse_in_area()

func _on_mouse_hit_box_mouse_entered():
	is_mouse_in_area = true
	
	check_farmer_in_area_and_mouse_in_area()

func _on_farmer_hit_box_area_exited(area:Area2D):
	is_farmer_in_area = false
	
	check_farmer_in_area_and_mouse_in_area()

func _on_mouse_hit_box_mouse_exited():
	is_mouse_in_area = false
	
	check_farmer_in_area_and_mouse_in_area()

func check_farmer_in_area_and_mouse_in_area():
	if is_farmer_in_area and is_mouse_in_area:
		emit_signal("farmer_and_mouse_in_area")
	else:
		emit_signal("farmer_and_mouse_not_in_area")

func _on_mouse_hit_box_input_event(viewport:Node, event:InputEvent, shape_idx:int):
	if not(is_farmer_in_area and is_mouse_in_area):
		return
	if event is InputEventMouseButton:
		if event.is_action_pressed("mouse_left_click"):
			
			emit_signal("left_mouse_clicked_while_farmer_and_mouse_in_area")

func force_update():
	$FarmerHitBox/CollisionShape2D.disabled = true
	$FarmerHitBox/CollisionShape2D.disabled = false
	$MouseHitBox/CollisionShape2D.disabled = true
	$MouseHitBox/CollisionShape2D.disabled = false


