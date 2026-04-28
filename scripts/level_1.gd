extends Node2D
@onready var Player = $Player
@onready var Bottom = $Bottom
@onready var Fork = $fork/AnimatableFork/Area2D
@onready var Knife_horizontal = $knife_horizontal/AnimatableBody2D/Area2D
@onready var oven_area = $oven/Area2D
@onready var oven_animation = $oven/AnimatedSprite2D
@onready var timer = $Player/CanvasLayer/Timer_scene
@onready var secret = $secret/Area2D
@onready var secret_texture = $secret/TextureRect

@onready var Cam = $Player/Camera2D

# Called when the node enters the scene tree for the first time.
# Початкова позиція плеєра (її можна встановити в будь-яку точку на рівні)
var spawn_position = Vector2(450, 900)  # Наприклад, (100, 100) — початкова точка

func _ready():
	SceneManager.level1_success = 0
	SceneManager.level1_success +=1
	secret_texture.texture = load("res://images/pizza_1.png")
	SceneManager.current_scene_path = "res://scenes/level_1.tscn"
	# Підключаємо сигнал body_entered від телепортаційної зони до методу
	Bottom.body_entered.connect(Callable(self, "_on_bottom_entered"))# Сигнал спрацьовує, коли плеєр входить в телепортаційну зону
	Fork.body_entered.connect(Callable(self, "_on_fork_entered"))
	Knife_horizontal.body_entered.connect(Callable(self, "_on_knife_horizontal_entered"))
	
	oven_area.body_entered.connect(Callable(self, "_on_oven_entered"))
	secret.body_entered.connect(Callable(self, "_on_secret_entered"))
	
	Cam.limit_left = 96
	Cam.limit_top = 175
	Cam.limit_right = 2040
	Cam.limit_bottom = 1005

func _process(delta):
	if timer.minutes == 0 and timer.seconds == 0:
		if oven_animation.animation != "unsuccess":
			oven_animation.play("unsuccess")
	else:
		if oven_animation.animation != "success":
			oven_animation.play("success")

func _on_secret_entered(body):
	if body.name == "Player" and secret_texture.texture != null:
		AudioManager.sfx2_play("secret")
		secret_texture.texture = null
		SceneManager.level1_success +=1

func _on_oven_entered(body):
	if body.name == "Player":
		AudioManager.sfx2_play("win")
		if timer.minutes != 0 or timer.seconds !=0:
			SceneManager.level1_success +=1
		SceneManager.previous_scene_path = SceneManager.current_scene_path
		get_tree().call_deferred("change_scene_to_file", "res://scenes/level_finished_menu.tscn")
		SceneManager.current_scene_path = "res://scenes/level_finished_menu.tscn"
		AudioManager.music_play()

func _on_bottom_entered(body):
	_death(body)
		
func _on_fork_entered(body):
	_death(body)
		
func _on_knife_horizontal_entered(body):
	_death(body)
	
func _death(body):
	# Перевіряємо, чи це плеєр
	if body == Player and !Player.invinceble:  # Перевіряємо, чи цей об'єкт — плеєр
		AudioManager.sfx1_play("death")
		# Відновлюємо плеєра на початкову позицію
		body.position = spawn_position
		secret_texture.texture = load("res://images/pizza_1.png")
		SceneManager.level1_success = 1
