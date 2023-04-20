extends ItemStrategy
class_name ItemStrategySell

@export var sell_price: int = 0

func _to_string() -> String:
    return "ขายในราคา " + str(sell_price) + " ทอง"
