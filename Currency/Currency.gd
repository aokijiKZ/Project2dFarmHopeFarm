extends Resource

class_name Currency

@export var currency_name: String = "Money"
@export var amount: float = 0:
	set(value):
		amount = value
		emit_signal("amount_changed")

signal amount_changed()

func earn(earn_amount: float):
	self.amount = amount+earn_amount
    
func spend(spend_amount: float) -> bool:
	if can_spend(spend_amount):
		self.amount = amount-spend_amount
		return true
	else:
		return false

func can_spend(spend_amount: float) -> bool:
	return spend_amount <= amount
