extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var file_paths = FileManager.get_files_in_dir("res://Item/", "tscn",['Item.tscn'], true)
	print("file_paths: ", file_paths)
	file_paths = FileManager.get_files_in_dir("res://Card/", "tscn",['Card.tscn'], true)
	print("file_paths: ", file_paths)
