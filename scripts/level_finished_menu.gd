extends Control

@onready var Back = $Panel/Back_Button
@onready var Retry = $Panel/Retry_Button
@onready var Next = $Panel/Next_Button

@onready var success_1 = $Panel/HBoxContainer1/MarginContainer/pizza1
@onready var success_2 = $Panel/HBoxContainer1/MarginContainer2/pizza2
@onready var success_3 = $Panel/HBoxContainer1/MarginContainer3/pizza3

var pizza_success = load("res://images/pizza_success_finished_level.png")
var pizza_unsuccess = load("res://images/pizza_unsuccess_finished_level.png")

func _ready() -> void:
	SceneManager.current_scene_path = "res://scenes/level_finished_menu.tscn"

	_success_levels()

	Back.pressed.connect(_on_back_button_pressed)
	Retry.pressed.connect(_on_retry_button_pressed)
	Next.pressed.connect(_on_next_button_pressed)

	if SceneManager.get_next_level_path(SceneManager.previous_scene_path) == "":
		Next.disabled = true

func _success_levels() -> void:
	success_1.texture = pizza_unsuccess
	success_2.texture = pizza_unsuccess
	success_3.texture = pizza_unsuccess

	var level_number = SceneManager.get_level_number_from_path(SceneManager.previous_scene_path)
	var success_count = SceneManager.get_level_success(level_number)

	if success_count >= 1:
		success_1.texture = pizza_success

	if success_count >= 2:
		success_2.texture = pizza_success

	if success_count >= 3:
		success_3.texture = pizza_success

func _on_back_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/chose_level_menu.tscn")
	SceneManager.current_scene_path = "res://scenes/chose_level_menu.tscn"
	AudioManager.music_play()

func _on_retry_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", SceneManager.previous_scene_path)
	SceneManager.current_scene_path = SceneManager.previous_scene_path
	AudioManager.music_play()

func _on_next_button_pressed() -> void:
	var next_level_path = SceneManager.get_next_level_path(SceneManager.previous_scene_path)

	if next_level_path != "":
		get_tree().call_deferred("change_scene_to_file", next_level_path)
		SceneManager.current_scene_path = next_level_path
		AudioManager.music_play()
