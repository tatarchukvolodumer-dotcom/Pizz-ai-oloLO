extends Control  # Робимо кастомний UI-елемент на базі Control

signal value_changed(value)  
# Сигнал, який буде викликатися кожного разу, коли змінюється значення слайдера
# value — нове значення

@onready var track: NinePatchRect = $Track  
# Посилання на "доріжку" слайдера (фон, по якому рухається повзунок)

@onready var fill: NinePatchRect = $Track/Fill  
# Посилання на заповнену частину (візуально показує значення)

@onready var mark: TextureRect = $Mark  
# Сам повзунок (ручка, яку тягне користувач)

const EDGE_MARGIN = 10.0  
# Відступ від країв, щоб повзунок не впирався прямо в край

@export var min_value: float = 0.0  
# Мінімальне значення (можна задати в Inspector для кожного слайдера)

@export var max_value: float = 100.0  
# Максимальне значення

@export var value: float = 50.0  
# Поточне значення слайдера

var dragging := false  
# Чи зараз користувач тягне повзунок (натиснута ліва кнопка миші)

func _ready() -> void:
	update_visuals()  
	# При запуску оновлюємо позицію повзунка і заповнення відповідно до value

func _gui_input(event):
	# Ця функція викликається при будь-якій взаємодії миші/клавіатури з цим Control

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# Якщо це клік лівою кнопкою миші

		if event.pressed:
			# Якщо кнопку натиснули
			dragging = true  
			# Починаємо "тягнути" слайдер
			update_slider()  
			# Одразу оновлюємо позицію

		else:
			# Якщо кнопку відпустили
			dragging = false  
			# Перестаємо тягнути

	elif event is InputEventMouseMotion and dragging:
		# Якщо рух миші і при цьому ми тягнемо
		update_slider()  
		# Оновлюємо значення слайдера

func update_slider():
	# Основна логіка обчислення значення

	var mouse_x = get_local_mouse_position().x  
	# Беремо X позицію миші відносно цього Control

	var left = track.position.x + EDGE_MARGIN  
	# Ліва межа руху повзунка

	var right = track.position.x + track.size.x - EDGE_MARGIN  
	# Права межа руху

	var width = right - left  
	# Довжина доступної області

	var clamped_x = clamp(mouse_x, left, right)  
	# Обмежуємо позицію миші в межах слайдера

	var t = (clamped_x - left) / width  
	# Нормалізуємо значення в діапазон 0..1

	value = lerp(min_value, max_value, t)  
	# Перетворюємо 0..1 у реальний діапазон (наприклад -40..0 для звуку)

	update_visuals()  
	# Оновлюємо візуал (повзунок і заповнення)

	value_changed.emit(value)  
	# Відправляємо сигнал, що значення змінилось

func update_visuals():
	# Оновлює тільки відображення (без логіки)

	var left = track.position.x + EDGE_MARGIN  
	# Ліва межа

	var right = track.position.x + track.size.x - EDGE_MARGIN  
	# Права межа

	var width = right - left  
	# Ширина

	var t = inverse_lerp(min_value, max_value, value)  
	# Перетворюємо value назад у 0..1 (щоб знати позицію)

	mark.position.x = left + t * width - mark.size.x / 2  
	# Розміщуємо повзунок по X

	mark.position.y = track.position.y + (track.size.y - mark.size.y) / 2  
	# Центруємо повзунок по Y

	fill.position.x = EDGE_MARGIN  
	# Початок заповнення

	fill.size.x = t * (track.size.x - EDGE_MARGIN * 2)  
	# Довжина заповнення залежить від значення
