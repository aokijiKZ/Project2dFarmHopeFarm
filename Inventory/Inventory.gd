extends Resource

class_name Inventory

@export var items: Dictionary:
	set(v):
		items = v
		emit_signal("items_changed")

signal items_changed

func validate_data() -> void:
	if items == null:
		items = {}
	else:
		for key in items.keys():
			if not key is String:
				print("Invalid item name: ", key)
				items.erase(key)
			elif not items[key] is int or items[key] <= 0:
				print("Invalid quantity for item '", key, "': ", items[key])
				items[key] = 0
	emit_signal("items_changed")

func add(item_name: String, quantity: int = 1) -> void:
	if items.has(item_name):
		items[item_name] += quantity
	else:
		items[item_name] = quantity
	emit_signal("items_changed")

func remove(item_name: String, quantity: int = 1) -> bool:
	if items.has(item_name):
		items[item_name] -= quantity
		if items[item_name] <= 0:
			items.erase(item_name)
		emit_signal("items_changed")
		return true
	else:
		return false

func clear() -> void:
	items.clear()
	emit_signal("items_changed")

func merge(second_inventory: Inventory) -> void:
	items.merge(second_inventory.items)
	emit_signal("items_changed")

func get_item_names() -> Array:
	return items.keys()

func get_item_quantity(item_name: String) -> int:
	if items.has(item_name):
		return items[item_name]
	else:
		return 0

func get_size()-> int:
	return items.size()

func _to_string() -> String:
	return "Inventory: " + str(items)



