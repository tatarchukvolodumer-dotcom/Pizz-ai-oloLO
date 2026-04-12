extends Node2D
@onready var Player = $Player
@onready var Bottom = $Bottom
@onready var Fork = $fork/AnimatableFork/Area2D
@onready var Knife_horizontal = $knife_horizontal/AnimatableBody2D/Area2D

@onready var Cam = $Player/Camera2D

# Called when the node enters the scene tree for the first time.
# Початкова позиція плеєра (її можна встановити в будь-яку точку на рівні)
var spawn_position = Vector2(434, 932)  # Наприклад, (100, 100) — початкова точка

func _ready():
	# Підключаємо сигнал body_entered від телепортаційної зони до методу
	Bottom.body_entered.connect(Callable(self, "_on_bottom_entered"))# Сигнал спрацьовує, коли плеєр входить в телепортаційну зону
	Fork.body_entered.connect(Callable(self, "_on_fork_entered"))
	Knife_horizontal.body_entered.connect(Callable(self, "_on_knife_horizontal_entered"))
	
	Cam.limit_left = 178
	Cam.limit_top = 5
	Cam.limit_right = 3420
	Cam.limit_bottom = 1175
	
	
func _on_bottom_entered(body):
	# Перевіряємо, чи це плеєр
	if body == Player:  # Перевіряємо, чи цей об'єкт — плеєр
		# Відновлюємо плеєра на початкову позицію
		body.position = spawn_position
		
func _on_fork_entered(body):
	# Перевіряємо, чи це плеєр
	if body == Player:  # Перевіряємо, чи цей об'єкт — плеєр
		# Відновлюємо плеєра на початкову позицію
		body.position = spawn_position
		
func _on_knife_horizontal_entered(body):
	# Перевіряємо, чи це плеєр
	if body == Player:  # Перевіряємо, чи цей об'єкт — плеєр
		# Відновлюємо плеєра на початкову позицію
		body.position = spawn_position
