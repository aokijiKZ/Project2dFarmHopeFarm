extends Node

# Time system variables
var current_second: int = 0

# Timer node reference
@onready var timer: Timer = $Timer

signal time_changed()

func _ready():
    # Connect the timer's timeout signal to the "_on_GameTimer_timeout" function
    timer.timeout.connect(_on_GameTimer_timeout)

func _on_GameTimer_timeout() -> void:
    current_second += 1

    emit_signal("time_changed")

func get_minute() -> int:
    return current_second / 60

func get_hour() -> int:
    return get_minute() / 60
