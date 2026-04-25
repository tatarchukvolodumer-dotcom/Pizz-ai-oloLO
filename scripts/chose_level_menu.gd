extends Control
@onready var level1_button = $Panel/VBoxContainer/level_button/HBoxContainer/level1_button/level1
@onready var level2_button = $Panel/VBoxContainer/level_button/HBoxContainer/level2_button/level2
@onready var level3_button = $Panel/VBoxContainer/level_button/HBoxContainer/level3_button/level3
@onready var back = $Panel/VBoxContainer/back_button/MarginContainer/Back

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneManager.current_scene_path = "res://scenes/chose_level_menu.tscn"
	level1_button.pressed.connect(_on_level1_button_pressed)
	level2_button.pressed.connect(_on_level2_button_pressed)
	level3_button.pressed.connect(_on_level3_button_pressed)
	back.pressed.connect(_on_back_button_pressed)
	
func _on_level1_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/level_1.tscn")
	SceneManager.current_scene_path = "res://scenes/level_1.tscn"
	AudioManager.music_play()
	
func _on_level2_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/level_2.tscn")
	SceneManager.current_scene_path = "res://scenes/level_.tscn"
	AudioManager.music_play()
	
func _on_level3_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/level_3.tscn")
	SceneManager.current_scene_path = "res://scenes/level_.tscn"
	AudioManager.music_play()
	
func _on_back_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/main_menu.tscn")
	SceneManager.current_scene_path = "res://scenes/main_menu.tscn"
	AudioManager.music_play()
