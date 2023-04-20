@tool
class_name Mine extends Node2D

enum TYPE { IRON_ORE, COPPER_ORE, GOLD_ORE }
var type = TYPE.IRON_ORE

enum STATE{
	NORMAL,
	BROKEN,
	DESTROYED,
}
var state = STATE.NORMAL

@export var iron_ore_package_scene: PackedScene
@export var copper_ore_package_scene: PackedScene
@export var gold_ore_package_scene: PackedScene
@export var empty_ground_object_packed_scene: PackedScene

func _ready():
	randomize()
	random_type()
	
func random_type():
	type = randi() % STATE.size()
	update_type()
	
func update_type():
	match type:
		TYPE.IRON_ORE:
			$AnimatedSprite2D.self_modulate = Color(1, 1, 1)
		TYPE.COPPER_ORE:
			$AnimatedSprite2D.self_modulate = Color(1, 0.5, 0.5)
		TYPE.GOLD_ORE:
			$AnimatedSprite2D.self_modulate = Color(1, 1, 0.5)

func update_state():
	match state:
		STATE.NORMAL:
			$AnimatedSprite2D.play("normal")
		STATE.BROKEN:
			$AnimatedSprite2D.play("broken")
		STATE.DESTROYED:
			$AnimatedSprite2D.play("destroyed")
			var inventory = get_tree().root.find_child("Farmer", true, false).inventory
			var item_pakaage_scene = null
			match type:
				TYPE.IRON_ORE:
					item_pakaage_scene = iron_ore_package_scene
				TYPE.COPPER_ORE:
					item_pakaage_scene = copper_ore_package_scene
				TYPE.GOLD_ORE:
					item_pakaage_scene = gold_ore_package_scene
			
			if item_pakaage_scene == null:
				printerr("item_pakaage_scene is null")
				return
			
			var item = item_pakaage_scene.instantiate()
			inventory.add_item(item)
			# await $AnimatedSprite2D.animation_finished
			if item_pakaage_scene != null:
				var empty_ground_object = empty_ground_object_packed_scene.instantiate()
				empty_ground_object.position = position
				var empty_ground_group = get_tree().root.find_child("EmptyGroundGroup", true, false)
				if empty_ground_group != null:
					empty_ground_group.call_deferred("add_child", empty_ground_object)

			queue_free()
	


func _on_pickaxe_hurt_box_area_entered(area:Area2D):
	
	
	state = state+1
	update_state()
