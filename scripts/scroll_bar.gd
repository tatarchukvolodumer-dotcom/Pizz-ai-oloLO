extends Control

@onready var track: NinePatchRect = $Track
@onready var fill: NinePatchRect = $Track/Fill
@onready var mark: TextureRect = $Mark

const EDGE_MARGIN = 10.0

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		update_slider()
	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		update_slider()

func update_slider():

	var mouse_x = get_local_mouse_position().x

	var left = track.position.x + EDGE_MARGIN
	var right = track.position.x + track.size.x - EDGE_MARGIN
	var width = right - left

	var clamped_x = clamp(mouse_x, left, right)
	var t = (clamped_x - left) / width

	# позиція повзунка
	mark.position.x = left + t * width - mark.size.x / 2
	mark.position.y = track.position.y + (track.size.y - mark.size.y) / 2

	# заповнення
	fill.position.x = EDGE_MARGIN
	fill.size.x = t * (track.size.x - EDGE_MARGIN * 2)
