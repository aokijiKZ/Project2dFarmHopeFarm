extends Node2D


var data : Dictionary

const json_file_path = "res://GameDatabase/database.json"
const img_file_path = "res://img_data/"

@export var imgs : Array[Texture] = []

@export var cards : Array[PackedScene] = []


func _ready():
	for t in imgs:
		print(t.resource_path)
	load_data()
	

func load_data():
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	if file == null:
		return null
	
	var strvar = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(strvar)
	if error == OK:
		data = json.data
	else:
		pass
		
	file.close()

func get_data(sheet_name:String,first_col_name:String) -> Dictionary:
	var sheet = data.get(sheet_name,{})
	var first_col = sheet.get(first_col_name,{})
	return first_col

func get_img(sheet_name:String,first_col_name:String,img_name:String,extention:String="") -> Texture:
	var base_path = img_file_path+sheet_name+"/"+first_col_name+'_'+img_name if img_name != "" else img_file_path+sheet_name+"/"+first_col_name
	
	if extention != "":
		var img_path = base_path+"."+extention
		if FileAccess.file_exists(img_path):
			return load(img_path)
	else:
		var support_img_extention = ["tres",'tres.remap',"png","jpg","jpeg","webp","tga","bmp","svg"]
		
		for ext in support_img_extention:
			var img_path = base_path+"."+ext
			print(img_path)
			for t in imgs:
				if t.resource_path == img_path:
					print("exist : "+img_path)
					return t
	return null

func get_imgs(sheet_name:String,first_col_name:String,img_name:String="",extention:String="")->Array[Texture]:
	var imgs :Array[Texture]= []
	var base_path = img_file_path+sheet_name+"/"+first_col_name+'_'+img_name if img_name != "" else img_file_path+sheet_name+"/"+first_col_name
	var index = 0
	while true:
		var img
		if img_name == "":
			img = get_img(sheet_name,first_col_name,""+str(index),extention)
		else:
			img = get_img(sheet_name,first_col_name,img_name+"_"+str(index),extention)
		if img == null:
			break
		imgs.append(img)
		index += 1

	return imgs
