extends Control


func _can_drop_data(at_position, data):
	return typeof(data) == TYPE_DICTIONARY and data.has("slot_index") 

func _drop_data(at_position, data):
	var slot_index = data["slot_index"]
	var farmer = get_tree().root.find_child("Farmer", true, false)
	var inventory = get_tree().root.find_child("Farmer", true, false).inventory
	var slot = inventory.get_child(slot_index)
	var item = slot.get_child(0)
	if item.is_consumable:
		farmer.stamina =  farmer.stamina + item.heal_stamina
		# todo :add more effect
		inventory.delete_item(item)
