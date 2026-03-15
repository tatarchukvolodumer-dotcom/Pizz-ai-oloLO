extends HBoxContainer

@onready var button_left = $Button_left
@onready var button_right = $Button_right
@onready var label_value = $Label

var options = ["30", "45", "60", "90", "180"]
var current_index = 0

func _ready():
	update_label()
	button_left.pressed.connect(_on_left_pressed)
	button_right.pressed.connect(_on_right_pressed)

func _on_left_pressed():
	current_index = (current_index - 1 + options.size()) % options.size()
	update_label()

func _on_right_pressed():
	current_index = (current_index + 1) % options.size()
	update_label()

func update_label():
	label_value.text = options[current_index]
