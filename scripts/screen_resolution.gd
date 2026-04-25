extends HBoxContainer

signal resolution_changed(resolution)

@onready var button_left = $Button_left
@onready var button_right = $Button_right
@onready var label_value = $Label

var options = [
	Vector2i(640, 480),
	Vector2i(1280, 720),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
	Vector2i(3480, 2160)
]

@export var current_index = 0

func _ready():
	update_label()
	button_left.pressed.connect(_on_left_pressed)
	button_right.pressed.connect(_on_right_pressed)

func _on_left_pressed():
	current_index = (current_index - 1 + options.size()) % options.size()
	update_label()
	emit_resolution()

func _on_right_pressed():
	current_index = (current_index + 1) % options.size()
	update_label()
	emit_resolution()

func update_label():
	var res = options[current_index]
	label_value.text = str(res.x) + " x " + str(res.y)

func emit_resolution():
	var res = options[current_index]
	resolution_changed.emit(res)
