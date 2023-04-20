class_name Item extends Resource

@export_category("Basic Item")
@export var item_name: String = ""
@export_multiline  var description: String = ""
@export var icon: Texture = null
@export var quantity: int = 1
@export_category("Special")
@export_group("Price")
@export var is_sellable: bool = false
@export var is_buyable: bool = false
@export var buy_price: int = 0
@export var sell_price: int = 0
@export_group("use")
@export var is_useable: bool = false
@export var is_consumed_on_use: bool = false
@export var restore_stamina : int = 0
@export var unlimit_stamina_time_sec : float = 0
@export_group('Seed')
@export var is_seedable: bool = false
@export var seed_texture: Texture = null
@export var grow_time_sec: float = 5
@export var crop_grow_textures: Array[Texture] = []
@export var crop_generate_oxygen: int = 0
@export_file('*tscn') var product_item_filepath :String = ''

func get_info() -> String:
	var info: String = "ชื่อไอเทม: " + item_name + "\n"
	info += "จำวนวน: " + str(quantity) + "\n" if quantity > 1 else ""
	info += "ราคาซื้อ: " + str(buy_price) + "\n"
	info += "ราคาขาย: " + str(sell_price) + "\n"
	info += "เพิ่มพลังชีวิต: " + str(restore_stamina) + "\n"
	info += "เวลาเพิ่มพลังชีวิตไม่จำกัด: " + str(unlimit_stamina_time_sec) + " วินาที\n"
	info += "เวลาปลูก: " + str(grow_time_sec) + " วินาที\n"
	info += "สร้างออกซิเจน: " + str(crop_generate_oxygen) + "\n"
	return info
