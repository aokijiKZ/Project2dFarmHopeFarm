extends ItemStrategy
class_name ItemStrategySeed

@export var grow_time_sec: float = 5
@export var crop_generate_oxygen: int = 0
@export var seed_texture: Texture = null
@export var crop_grow_textures: Array[Texture] = []
@export_file('*.tres') var product_item_filepath: String = ''

func _to_string() -> String:
    var product_item_name: String = load(product_item_filepath).item_name if product_item_filepath != ''  else ""
    var text = "ใช้สำหรับปลูก ใช้ %d วิ ในการโต \nให้ออกซิเจน %d  หน่วย \nให้ผลผลิตเป็น %s" % [
        grow_time_sec,
        crop_generate_oxygen,
        product_item_name,
    ]
    return text