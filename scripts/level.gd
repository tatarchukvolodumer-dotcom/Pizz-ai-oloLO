extends Node2D

@onready var Player = $Player
@onready var timer = $Player/CanvasLayer/Timer_scene
@onready var Oven_area = $oven/Area2D
@onready var oven_animation = $oven/AnimatedSprite2D
@onready var secret = $secret/Area2D
@onready var secret_texture = $secret/TextureRect

var spawn_position = Vector2(0, 0)
var pizza = load("res://images/pizza_2.png")
var level_number = 0
var result = 1

func _ready():
	_set_for_son()
	
	secret_texture.texture = pizza
	SceneManager.current_scene_path = get_tree().current_scene.scene_file_path
	Oven_area.body_entered.connect(_on_oven_entered)
	secret.body_entered.connect(_on_secret_entered)
	for area in get_tree().get_nodes_in_group("_death_area"):
		if area is Area2D:
			area.body_entered.connect(_death)

func _process(delta):
	if timer.minutes == 0 and timer.seconds == 0:
		if oven_animation.animation != "unsuccess":
			oven_animation.play("unsuccess")
	else:
		if oven_animation.animation != "success":
			oven_animation.play("success")

func _on_secret_entered(body):
	if body == Player and secret_texture.texture != null:
		AudioManager.sfx2_play("secret")
		secret_texture.texture = null
		result += 1

func _on_oven_entered(body):
	if body == Player:
		AudioManager.sfx2_play("win")
		if timer.minutes != 0 or timer.seconds != 0:
			result += 1
		SceneManager.set_level_success(level_number, result)
		print("Level ", level_number, " result: ", result)
		SceneManager.previous_scene_path = SceneManager.current_scene_path
		get_tree().call_deferred("change_scene_to_file", "res://scenes/level_finished_menu.tscn")
		SceneManager.current_scene_path = "res://scenes/level_finished_menu.tscn"
		AudioManager.music_play()

func _death(body):
	if body == Player and !Player.invincible:
		AudioManager.sfx1_play("death")
		body.position = spawn_position
		secret_texture.texture = pizza
		result = 1

func _set_for_son():
	timer.set_time(0, 0)
	Player._set_cam(0, 0, 0, 0)
	pizza = load("res://images/pizza_2.png")
	spawn_position = Vector2(0, 0)
	level_number = 1
