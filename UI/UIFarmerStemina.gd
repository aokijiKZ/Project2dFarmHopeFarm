extends TextureProgressBar

var farmer = null

func _process(delta):
	if farmer==null:
		farmer = get_tree().root.find_child("Farmer", true, false)
		if farmer!=null:
			update()
			farmer.stamina_changed.connect(update)
			farmer.is_unlimit_stamina_changed.connect(update_color)

func update():
	print("Updating stamina bar")
	print("Stamina: " + str(farmer.stamina))
	print("Max stamina: " + str(farmer.max_stamina))
	value = Utility.value_to_percent(farmer.stamina, farmer.max_stamina)
	print("Stamina bar value: " + str(value))
	$value.text = "%d/%d"%[farmer.stamina, farmer.max_stamina]

func update_color():
	if farmer.is_unlimit_stamina:
		self_modulate = Color(0.14, 0.51, 0.83)
	else:
		self_modulate = Color(1, 1, 1)