extends "res://Menu/InteractGroundMenu/InteractGroundMenu.gd"

@export var water_bg : Texture
@onready var prve_bg : Texture = $Bg/groundBg.texture

var is_water_button_down : bool = false

func _ready() -> void:
	super._ready()

func _process(delta: float) -> void:
	if is_water_button_down:
		$WaterBar.value = float($WaterBar.value) + (50.0 *delta)
		if $WaterSoundPlayer.playing == false:
			$WaterSoundPlayer.play()

func _on_water_button_button_down() -> void:
	var farmer = get_tree().root.find_child("Farmer", true, false)
	if farmer == null:
		printerr("Farmer not found")
		return
	if farmer.stamina <= 0:
		farmer.talk('เหนื่อย! [พลังงานหมดแล้ว]')
		hide()
		queue_free()
	farmer.stamina = farmer.stamina - 1
	$Bg/groundBg.texture = water_bg
	is_water_button_down = true

func _on_water_button_button_up() -> void:
	$Bg/groundBg.texture = prve_bg
	is_water_button_down = false

	if $WaterBar.value >= 60 and $WaterBar.value < 80:
		emit_signal("completed_interact")
		print("completed_interact")
	
	hide()
	queue_free()
