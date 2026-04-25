extends Control

@onready var Back = $Panel/Back_Button
@onready var Retry = $Panel/Retry_Button
@onready var Next = $Panel/Next_Button

@onready var success_1 = $Panel/HBoxContainer1/MarginContainer/pizza1
@onready var success_2 = $Panel/HBoxContainer1/MarginContainer2/pizza2
@onready var success_3 = $Panel/HBoxContainer1/MarginContainer3/pizza3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	success_1.texture = load("res://images/pizza_unsuccess_finished_level.png")
	success_2.texture = load("res://images/pizza_unsuccess_finished_level.png")
	success_3.texture = load("res://images/pizza_unsuccess_finished_level.png")
	SceneManager.current_scene_path = "res://scenes/level_finished_menu.tscn"
	_success_levels()
	Back.pressed.connect(_on_back_button_pressed)
	Retry.pressed.connect(_on_retry_button_pressed)
	Next.pressed.connect(_on_next_button_pressed)
	if SceneManager.previous_scene_path == "res://scenes/level_3.tscn":
		Next.disabled = true;

func _success_levels() -> void:
	if SceneManager.previous_scene_path == "res://scenes/level_1.tscn":
		if SceneManager.level1_success >= 1:
			success_1.texture = load("res://images/pizza_success_finished_level.png")
		if 	SceneManager.level1_success >= 2:
			success_2.texture = load("res://images/pizza_success_finished_level.png")
		if SceneManager.level1_success == 3:
			success_3.texture = load("res://images/pizza_success_finished_level.png")
	elif SceneManager.previous_scene_path == "res://scenes/level_2.tscn":
		if SceneManager.level2_success >= 1:
			success_1.texture = load("res://images/pizza_success_finished_level.png")
		if 	SceneManager.level2_success >= 2:
			success_2.texture = load("res://images/pizza_success_finished_level.png")
		if SceneManager.level2_success == 3:
			success_3.texture = load("res://images/pizza_success_finished_level.png")
	elif SceneManager.previous_scene_path == "res://scenes/level_3.tscn":
		if SceneManager.level3_success >= 1:
			success_1.texture = load("res://images/pizza_success_finished_level.png")
		if 	SceneManager.level3_success >= 2:
			success_2.texture = load("res://images/pizza_success_finished_level.png")
		if SceneManager.level3_success == 3:
			success_3.texture = load("res://images/pizza_success_finished_level.png")

func _on_back_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/chose_level_menu.tscn")
	SceneManager.current_scene_path = "res://scenes/chose_level_menu.tscn"
	AudioManager.music_play()

func _on_retry_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", SceneManager.previous_scene_path)
	SceneManager.current_scene_path = SceneManager.previous_scene_path
	AudioManager.music_play()

func _on_next_button_pressed() -> void:
	if SceneManager.previous_scene_path == "res://scenes/level_1.tscn":
		get_tree().call_deferred("change_scene_to_file", "res://scenes/level_2.tscn")
		SceneManager.current_scene_path = "res://scenes/level_2.tscn"
		AudioManager.music_play()
	elif SceneManager.previous_scene_path == "res://scenes/level_2.tscn":
		get_tree().call_deferred("change_scene_to_file", "res://scenes/level_3.tscn")
		SceneManager.current_scene_path = "res://scenes/level_3.tscn"
		AudioManager.music_play()
