extends Node

var prve_scene_data :Dictionary = {}
var prve_scene :Node

func change_scene_with_path(new_scene_path: String,pass_data:Dictionary={},animetion_name:String="") -> void:
	if new_scene_path == "":
		printerr("new_scene_path is null")
		return
	var current_scene_node = get_tree().root.get_child(-1)
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished 
	get_tree().root.remove_child(current_scene_node)
	if prve_scene != null:
		prve_scene.queue_free()
	prve_scene = current_scene_node
	var new_scene = load(new_scene_path).instantiate()
	get_tree().root.add_child(new_scene)
	$AnimationPlayer.play("fade_out")
	prve_scene_data = pass_data
	await $AnimationPlayer.animation_finished 

func change_scene_with_package_scene(new_scene_package: PackedScene,pass_data:Dictionary={},animetion_name:String="") -> void:
	if new_scene_package == null:
		printerr("new_scene_package is null")
		return
	var current_scene_node = get_tree().root.get_child(-1)
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished 
	get_tree().root.remove_child(current_scene_node)
	if prve_scene != null:
		prve_scene.queue_free()
	prve_scene = current_scene_node
	var new_scene = new_scene_package.instantiate()
	get_tree().root.add_child(new_scene)
	$AnimationPlayer.play("fade_out")
	prve_scene_data = pass_data
	await $AnimationPlayer.animation_finished


func back_to_prev_scene():
	if prve_scene == null:
		printerr("prve_scene is null")
		return
	var current_scene_node = get_tree().root.get_child(-1)
	$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished 
	get_tree().root.remove_child(current_scene_node)
	get_tree().root.add_child(prve_scene)
	$AnimationPlayer.play("fade_out")
	await $AnimationPlayer.animation_finished
	prve_scene = current_scene_node

func reload_current_scene():
	var current_scene_node = get_tree().root.get_child(-1)
	change_scene_with_path(current_scene_node.scene_file_path,prve_scene_data)
