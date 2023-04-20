extends ItemStrategy
class_name ItemStrategyBuy

@export var buy_price: int = 0

func _to_string() -> String:
    return "ราคาซื้อ %d ทอง" % buy_price