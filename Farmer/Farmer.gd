extends CharacterBody2D

@export var speed := 16*3
var direction := Vector2(0, 1)

@export var max_stamina := 10:
	set(v):
		max_stamina = v
		stamina = max_stamina
		emit_signal("max_stamina_changed")
	
var stamina := max_stamina :
	set(v):
		stamina = clampi(v, 0, max_stamina)
		emit_signal("stamina_changed")

var can_move := true
var is_unlimit_stamina := false :
	set(v):
		is_unlimit_stamina = v
		emit_signal("is_unlimit_stamina_changed")

signal stamina_changed()
signal max_stamina_changed()
signal is_unlimit_stamina_changed()


func _physics_process(delta):
	# Only move if the player is in the idle or walking state
	if $AnimationTree.get("parameters/playback").get_current_node() in ['Idle', 'Walk'] and can_move:
		# Set the velocity based on the input
		velocity.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		velocity.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		velocity = velocity.normalized() * speed
		# If the player is moving, update the direction
		if velocity.length() > 0:
			direction = velocity.normalized()
		# Move the player
		move_and_slide()

		# Update animation
		$AnimationTree.set('parameters/Walk/blend_position', direction)
		$AnimationTree.set('parameters/Idle/blend_position', direction)
		
		# Update the hitbox position
		if direction.x!=0:
			$in_font_player_position.position = Vector2(direction.x/abs(direction.x)* 10,0)
		elif direction.y!=0:
			$in_font_player_position.position = Vector2(0,direction.y/abs(direction.y)*10)

func _process(delta: float) -> void:
	if is_unlimit_stamina:
		stamina = max_stamina
		print("unlimit")
		

func use_item(item_data:Dictionary):
	print('farmer use item ',item_data)
	var restore_stamina = item_data.get('restore_energy_point',0)
	if restore_stamina > 0:
		stamina = stamina + restore_stamina
		talk('สดชื่น! [ได้รับพลังงาน ' + str(restore_stamina) + ' แต้ม]')
	
	var unlimit_energy_time_sec = item_data.get('unlimit_energy_time_sec',0)
	if unlimit_energy_time_sec >0:
		is_unlimit_stamina = true
		get_tree().create_timer(unlimit_energy_time_sec).timeout.connect(func(): is_unlimit_stamina = false)
		talk('สดชื่นอย่างมาก! [ใช้พลังงานได้ตลอดใน ' + str(unlimit_energy_time_sec) + ' วิ]')

	var game = get_tree().root.find_child("Game",true,false)
	if game == null:
		printerr("No game found")
		return
	var inventory :Inventory = game.inventory
	inventory.remove(item_data.get('name',''))

var is_talk = false
func talk(text:String):
	if is_talk:
		return
	is_talk = true
	$z_index_5/conversation.text = text
	$z_index_5/conversation/AnimationPlayer.play("show_text")
	await $z_index_5/conversation/AnimationPlayer.animation_finished
	is_talk = false


func _on_stamina_changed() -> void:
	if stamina == 0:
		talk('เหนื่อย! [พลังงานหมดแล้ว]')


func force_refesh_area():
	$FarmerHurtBox/CollisionShape2D.disabled = true
	await get_tree().create_timer(0.1).timeout
	$FarmerHurtBox/CollisionShape2D.disabled = false