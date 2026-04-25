extends Control
@onready var play = $play_button
@onready var settings = $settings_button
@onready var exit = $exit_button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneManager.current_scene_path = "res://scenes/main_menu.tscn"
	play.pressed.connect(_on_play_button_pressed)
	settings.pressed.connect(_on_settings_button_pressed)
	exit.pressed.connect(_on_exit_button_pressed)

func _on_play_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/saving_menu.tscn")
	SceneManager.current_scene_path = "res://scenes/saving_menu.tscn"
	AudioManager.music_play()

func _on_settings_button_pressed() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/settings_menu.tscn")
	SceneManager.current_scene_path = "res://scenes/settings_menu.tscn"
	AudioManager.music_play()
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()
	
