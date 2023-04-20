extends ItemStrategy
class_name ItemStrategyUse

@export var consume_heal_hp : int = 0
@export var consume_heal_stamina : int = 0
@export var consume_unlimit_stamina_time_sec : int = 0
@export var is_comsume_on_use : bool = true

func _to_string() -> String:
    var text = "ใช้ "
    text = text + "เพิ่มพลังชีวิต %s หน่วย  "%consume_heal_hp  if consume_heal_hp > 0 else ""
    text = text + "เพิ่มพลังงาน %s หน่วย "%consume_heal_stamina  if consume_heal_stamina > 0 else ""
    text = text + "พลังไร้ขีดจำกัดใน %s วินาที "%consume_unlimit_stamina_time_sec  if consume_unlimit_stamina_time_sec > 0 else ""
    return text
