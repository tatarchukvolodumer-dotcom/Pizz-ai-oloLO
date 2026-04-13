extends Node2D
@onready var Player = $Player
@onready var Bottom = $Bottom
@onready var Fork = load("res://scenes/fork.tscn")
@onready var Knife_r = load("res://scenes/knife_rotation.tscn")
@onready var Knife_h = load("res://scenes/knife_horizontal.tscn")
@onready var Plate = load("res://scenes/plate.tscn")

@onready var Cam = $Player/Camera2D

var fork_positions = [
	Vector2(1600, 1110), #Y-1
	Vector2(1125, 630),
	Vector2(650, 1110) #Y-1
]

var knife_r_position = [
	Vector2(2000, 1060),
	Vector2(3000, 980)
]

var knife_h_position = [
	Vector2(1900, 300),
	Vector2(1100, 300),
	Vector2(1300, 400) #X-1
]

var plate_position = [
	Vector2(1420, 450),
	Vector2(1280, 450), #X-1
	Vector2(1730, 990), #X-1
	Vector2(2500, 930),
	#Vector2(2500, 800),
	Vector2(650, 990)
]

# Called when the node enters the scene tree for the first time.
# Початкова позиція плеєра (її можна встановити в будь-яку точку на рівні)
var spawn_position = Vector2(450, 900)  # Наприклад, (100, 100) — початкова точка

func _ready():
	Bottom.body_entered.connect(Callable(self, "_on_bottom_entered"))# Сигнал спрацьовує, коли плеєр входить в телепортаційну зону
	
	for pos in fork_positions:
		var instance = Fork.instantiate()
		instance.position = pos
		if instance.position.y > 630:
			instance.scale.y = -1
		var area = instance.get_node("AnimatableFork/Area2D")
		area.body_entered.connect(_on_fork_entered)
		add_child(instance)
	
	for pos in plate_position:
		var instance = Plate.instantiate()
		instance.position = pos
		if instance.position.x == 1280 or instance.position.x == 1730:
			instance.scale.x = -1
		add_child(instance)
	
	for pos in knife_h_position:
		var instance = Knife_h.instantiate()
		instance.position = pos
		if instance.position.y == 400:
			instance.scale.x = -1
		var area = instance.get_node("AnimatableBody2D/Area2D")
		area.body_entered.connect(_on_knife_horizontal_entered)
		add_child(instance)
	
	for pos in knife_r_position:
		var instance = Knife_r.instantiate()
		instance.position = pos
		add_child(instance)
	
	Cam.limit_left = 178
	Cam.limit_top = 5
	Cam.limit_right = 3420
	Cam.limit_bottom = 1175
	
	
func _on_bottom_entered(body):
	_death(body)
		
func _on_fork_entered(body):
	_death(body)
		
func _on_knife_horizontal_entered(body):
	_death(body)
		
func _death(body):
	# Перевіряємо, чи це плеєр
	if body == Player and !Player.invinceble:  # Перевіряємо, чи цей об'єкт — плеєр
		# Відновлюємо плеєра на початкову позицію
		body.position = spawn_position
