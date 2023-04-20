extends Node

const SETTING_PATH = "user://setting.save"

var setting = {
	"music_volume":scale_volume_db_to_percent(AudioServer.get_bus_volume_db(AudioServer.get_bus_index('Music'))),
	"effect_volume":scale_volume_db_to_percent(AudioServer.get_bus_volume_db(AudioServer.get_bus_index('Effect'))),
	"dialog_volume":scale_volume_db_to_percent(AudioServer.get_bus_volume_db(AudioServer.get_bus_index('Dialog'))),
}

func _ready():
	var load_setting = FileManager.load(SETTING_PATH)
	setting = load_setting if load_setting!= null else setting
	set_music_volume(setting["music_volume"])
	set_effect_volume(setting["effect_volume"])
	set_dialog_volume(setting["dialog_volume"])

func set_music_volume(percent):
	setting["music_volume"] = percent
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Music'), scale_percent_to_volume_db(percent))

func set_effect_volume(percent):
	setting["effect_volume"] = percent
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Effect'), scale_percent_to_volume_db(percent))

func set_dialog_volume(percent):
	setting["dialog_volume"] = percent
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Dialog'), scale_percent_to_volume_db(percent))

func scale_percent_to_volume_db(value_rescale):
	var volume_db = (value_rescale-100)/(-100)*-50
	return volume_db

func scale_volume_db_to_percent(volume_db):
	var value_rescale = ((volume_db/-50)*-100)+100
	return value_rescale

func get_music_volume():
	return setting["music_volume"]

func get_effect_volume():
	return setting["effect_volume"]

func get_dialog_volume():
	return setting["dialog_volume"]

func save():
	FileManager.save(SETTING_PATH, setting)

func _exit_tree():
	save()

func _on_tree_exiting() -> void:
	save()
