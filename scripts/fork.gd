extends Node2D


@onready var texture_rect = $AnimatableFork/Texture

# Функція для початку анімації
func _ready():
	# Додаємо ключові кадри для flip_h на 2.5 секунд
	start_flip_v_animation()
	
func start_flip_v_animation():
	var time_passed = 0.0
	var flip_state = false
	
	# Створюємо таймер для перевертання
	while true:
		await get_tree().create_timer(2.5).timeout  # Використовуємо await замість yield
		time_passed +=2.5
		flip_state = !flip_state  # Перемикаємо стан
		texture_rect.flip_v = flip_state  # Змінюємо flip_h
