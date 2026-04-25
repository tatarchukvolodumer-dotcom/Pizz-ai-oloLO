extends Button

@export var label_color : Label
@export var left_icon : Button
@export var right_icon : Button
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(pressing)

func pressing():
	if icon != null:
		icon = null
		label_color.add_theme_color_override("font_color", Color.html("#FFFBC6"))
		left_icon.icon = load("res://images/inactive_button_left.png")
		right_icon.icon = load("res://images/inactive_button_right.png")
		
	else:
		icon = load("res://images/radio_button_mark.png")
		label_color.add_theme_color_override("font_color", Color.html("#FF9603"))
		left_icon.icon = load("res://images/button_left.png")
		right_icon.icon = load("res://images/button_right.png")
