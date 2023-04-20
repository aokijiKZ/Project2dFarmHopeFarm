class_name Card extends Node2D


@export_category("Basic Card")
@export var card_name:String
@export_multiline var desc:String
@export var pic:Texture
@export_group("Buff",'buff_')
@export var buff_energy:int
# @export var buff_oxygen:int
@export var buff_move_speed:int
@export var buff_start_item_names:Array[String]

func get_buff_info() -> String:
	var buff_str = "โบนัส:\n"
	if buff_energy != 0:
		buff_str += "พลังงาน: +" + str(buff_energy) + "\n"
	if buff_move_speed != 0:
		buff_str += "ความเร็วเคลื่อนที่: +" + str(buff_move_speed) + "\n"
	if buff_start_item_names.size() > 0:
		buff_str += "ไอเทมเริิ่มต้น: \n"
		for item_name in buff_start_item_names:
			var item_data = GameDatabase.get_data("item", item_name)
			buff_str += " - " + item_data.get('display_name') + "\n"
	return buff_str