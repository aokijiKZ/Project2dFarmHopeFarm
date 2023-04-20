extends Resource

class_name Shop

var items_for_sale: Array = []  # Array of item names
var player_inventory: Inventory
var money_currency: Currency
var order_inventory = Inventory.new()

func setup(_items_for_sale: Array, _player_inventory: Inventory, _money_currency: Currency) -> void:
	items_for_sale = _items_for_sale
	player_inventory = _player_inventory
	money_currency = _money_currency

func add_funds(amount: int) -> void:
	money_currency.earn(amount)

func remove_funds(amount: int) -> bool:
	return money_currency.spend(amount)

func add_item_to_order(item_name: String, quantity: int = 1) -> bool:
	if items_for_sale.has(item_name):
		var item_data = GameDatabase.get_data('item',item_name)
		var item_buy_price = item_data.get('buy_price',0)
		if remove_funds(item_buy_price * quantity):
			order_inventory.add(item_name, quantity)
			return true
	return false

func remove_item_from_order(item_name: String, quantity: int = 1) -> bool:
	var item_data = GameDatabase.get_data('item',item_name)
	var item_buy_price = item_data.get('buy_price',0)
	add_funds(item_buy_price * quantity)
	return order_inventory.remove(item_name, quantity)

func clear_order() -> void:
	for item_name in order_inventory.get_item_names():
		remove_item_from_order(item_name, order_inventory.get_item_quantity(item_name))
	order_inventory.clear()

func confirm_order() -> Inventory:
	var order = order_inventory.duplicate()
	order_inventory.clear()
	return order

func sell_item(item_name: String, quantity: int = 1) -> bool:
	if player_inventory.remove(item_name, quantity):
		var item_data = GameDatabase.get_data('item',item_name)
		var item_sell_price = item_data.get('sell_price',0)
		add_funds(item_sell_price*quantity)  # Assuming 1 unit of currency for each item
		return true
	return false

func sell_items() -> bool:
	var success = true
	for item_name in player_inventory.get_item_names():
		var item_data = GameDatabase.get_data('item',item_name)
		var item_sell_price = item_data.get('sell_price',0)
		if item_sell_price > 0:
			var quantity = player_inventory.get_item_quantity(item_name)
			if not sell_item(item_name, quantity):
				success = false
	return success

func _to_string() -> String:
	return "Shop " + str(items_for_sale)
