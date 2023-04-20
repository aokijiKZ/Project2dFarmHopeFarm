extends Control

@export_file('*.dtl') var dialogic_timeline_path : String

var dialog_node 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if dialogic_timeline_path == null:
		return

	get_tree().paused = true
	dialog_node = Dialogic.start(load(dialogic_timeline_path))
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	dialog_node.process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta) -> void:
	if get_node("/root/Dialogic/Audio/Music").bus != 'Music':
		get_node("/root/Dialogic/Audio/Music").bus = 'Music'

func _on_timeline_ended() -> void:
	hide()
	queue_free()	
	
func _on_skip_button_after_play_press_sound() -> void:
	get_node("/root/Dialogic/Audio/Music").stop()
	Dialogic.end_timeline()
	hide()
	queue_free()


func _exit_tree() -> void:
	get_tree().paused = false

func _on_tree_exiting() -> void:
	get_tree().paused = false



