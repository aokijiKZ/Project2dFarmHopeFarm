extends Node2D

var SAVE_GAME_PATH = "user://save_game.save"

@export var user_name :String= ""
@export var stat :Dictionary= {}
@export_file('*.tscn') var current_card_path :String :
	set(value):
		current_card_path = value
		emit_signal("current_card_path_changed")
@export var unlocked_cards_path :Array[String]


#flag
var is_first_time_complate_game = true
var is_first_time_open_game = true
var is_first_time_in_area_selection = true
var is_first_time_recive_card = true
var is_first_time_in_shop = true
var is_first_time_in_game = true


signal current_card_path_changed()

func _ready():
	var load_data = FileManager.load(SAVE_GAME_PATH)
	if load_data != null:
		user_name = load_data.get("user_name","")
		stat = load_data.get("stat",{})
		current_card_path = load_data.get("current_card_path","")
		unlocked_cards_path = load_data.get("unlocked_cards_path",[])
		is_first_time_complate_game = load_data.get("is_first_time_complate_game",true)
		is_first_time_open_game = load_data.get("is_first_time_open_game",true)
		is_first_time_in_area_selection = load_data.get("is_first_time_in_area_selection",true)
		is_first_time_recive_card = load_data.get("is_first_time_recive_card",true)
		is_first_time_in_shop = load_data.get("is_first_time_in_shop",true)
		is_first_time_in_game = load_data.get("is_first_time_in_game",true)

func save():
	var save_data = {
		"user_name": user_name,
		"stat": stat,
		"current_card_path": current_card_path,
		"unlocked_cards_path": unlocked_cards_path,
		"is_first_time_complate_game": is_first_time_complate_game,
		"is_first_time_open_game": is_first_time_open_game,
		"is_first_time_in_area_selection": is_first_time_in_area_selection,
		"is_first_time_recive_card": is_first_time_recive_card,
		"is_first_time_in_shop": is_first_time_in_shop,
		"is_first_time_in_game": is_first_time_in_game,
	}
	FileManager.save(SAVE_GAME_PATH, save_data)

func _exit_tree():
	save()

func _on_tree_exiting() -> void:
	save()


func add_stat(level_path, used_time, recived_oxygen, complate_percent, is_complate):
	var key = level_path
	#override
	stat[key] = {
		"used_time": used_time,
		"recived_oxygen": recived_oxygen,
		"complate_percent": complate_percent,
		"is_complate": is_complate
	}

func update_stat(level_path, used_time, recived_oxygen, complate_percent, is_complate):
	var key = level_path
	var current_stat = stat.get(key, {})

	# Check if there is an existing stat entry for the level, and update it with the best values.
	if current_stat:
		if used_time < current_stat.get("used_time", used_time) or current_stat.get("used_time", -1) == -1:
			current_stat["used_time"] = used_time

		if recived_oxygen > current_stat.get("recived_oxygen", recived_oxygen):
			current_stat["recived_oxygen"] = recived_oxygen

		if complate_percent > current_stat.get("complate_percent", complate_percent):
			current_stat["complate_percent"] = complate_percent

		if is_complate:
			current_stat["is_complate"] = is_complate
	else:
		# If there is no existing stat entry, create a new one with the given values.
		current_stat = {
			"used_time": used_time,
			"recived_oxygen": recived_oxygen,
			"complate_percent": complate_percent,
			"is_complate": is_complate
		}

	stat[key] = current_stat


func get_stat(level_path):
	var key = level_path
	return stat.get(key,{})

func get_used_time(level_path):
	var key = level_path
	return stat.get(key,{}).get("used_time",0)

func get_received_oxygen(level_path):
	var key = level_path
	return stat.get(key,{}).get("recived_oxygen",0) 

func get_complate_percent(level_path):
	var key = level_path
	return stat.get(key,{}).get("complate_percent",0)

func get_is_complate(level_path):
	var key = level_path
	return stat.get(key,{}).get("is_complate",false)

func is_has_stat(level_path):
	var key = level_path
	return stat.has(key)

func get_total_oxygen():
	var total_oxygen = 0
	for key in stat.keys():
		total_oxygen += stat[key].get("recived_oxygen", 0)
	return total_oxygen
