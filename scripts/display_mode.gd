extends HBoxContainer

signal mode_changed(mode_value)

@onready var button_left = $Button_left
@onready var button_right = $Button_right
@onready var label_value = $Label

var options = [
	{"label": "Windowed", "value": "windowed"},
	{"label": "Windowed Fullscreen", "value": "windowed_fullscreen"},
	{"label": "Fullscreen", "value": "fullscreen"}
]
@export var current_index = 0

func _ready():
	update_label()
	button_left.pressed.connect(_on_left_pressed)
	button_right.pressed.connect(_on_right_pressed)

func _on_left_pressed():
	current_index = (current_index - 1 + options.size()) % options.size()
	update_label()
	emit_mode()

func _on_right_pressed():
	current_index = (current_index + 1) % options.size()
	update_label()
	emit_mode()

func update_label():
	label_value.text = options[current_index]["label"]
	
func emit_mode() -> void:
	mode_changed.emit(options[current_index]["value"])
