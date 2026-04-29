extends Control

@export var Dseconds: int = 0
@export var Dminutes: int = 0

var seconds = 0
var minutes = 0

func _ready() -> void:
	$Timer.timeout.connect(_on_timer_timeout)
	_reset_timer()

func set_time(new_minutes: int, new_seconds: int) -> void:
	Dminutes = new_minutes
	Dseconds = new_seconds
	_reset_timer()

func _on_timer_timeout() -> void:
	if seconds == 0:
		if minutes > 0:
			minutes -= 1
			seconds = 60

	seconds -= 1

	if seconds <= 0 and minutes <= 0:
		seconds = 0
		minutes = 0
		$Timer.stop()

	_update_label()

func _reset_timer() -> void:
	seconds = Dseconds
	minutes = Dminutes
	_update_label()

func _update_label() -> void:
	$Label.add_theme_constant_override("outline_size", 7)
	$Label.add_theme_color_override("font_outline_color", Color.BLACK)
	$Label.text = "%02d:%02d" % [minutes, seconds]
