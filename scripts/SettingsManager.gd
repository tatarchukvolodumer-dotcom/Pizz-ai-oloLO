extends Node

const SAVEFILE = "user://SAVEFILE.save"

var game_data = {}

# Тут буде зберігатися посилання на CanvasModulate,
# через який змінюється загальна яскравість сцени.
var brightness_layer: CanvasModulate = null



func _ready():
	# При запуску гри:
	# 1) завантажуємо налаштування з файлу або створюємо дефолтні;
	# 2) одразу застосовуємо їх до гри.
	load_data()
	apply_all_settings()

# Повертає словник стандартних налаштувань.
# Це зручно, бо тепер дефолтні значення зберігаються в одному місці,
# а не дублюються в різних функціях.
func get_default_settings() -> Dictionary:
	return {
		# Audio
		"master_vol": -10,
		"music_vol": -10,
		"sfx_vol": -10,

		# Display
		"screen_resolution": Vector2i(1920, 1080),
		"display_mode": "windowed",

		# Graphics
		"brightness": 1.0,

		# Performance
		"fps_lock_enabled": false,
		"max_fps": 60,

		# Video
		"vsync_on": false
	}

# Завантажує налаштування з файлу.
# Якщо файлу ще немає, створює словник дефолтних значень
# і одразу зберігає його.
func load_data():
	if not FileAccess.file_exists(SAVEFILE):
		game_data = get_default_settings()
		save_data()
		return

	var file = FileAccess.open(SAVEFILE, FileAccess.READ)
	game_data = file.get_var()

	# На випадок, якщо у старому save-файлі не вистачає якихось нових ключів,
	# можна "доукомплектувати" словник дефолтними значеннями.
	# Це корисно, якщо ти потім додаєш нові налаштування у проєкт.
	var defaults = get_default_settings()
	for key in defaults.keys():
		if not game_data.has(key):
			game_data[key] = defaults[key]

# Функція зберігає поточний словник game_data у файл.
func save_data():
	var file = FileAccess.open(SAVEFILE, FileAccess.WRITE)
	# Записуємо весь словник у файл.
	file.store_var(game_data)
	
# Застосовує абсолютно всі налаштування.
# Це зручно викликати після завантаження, після скидання на дефолт,
# або після повернення до збереженого стану.
func apply_all_settings() -> void:
	apply_audio_settings()
	apply_display_mode()
	apply_resolution()
	apply_video_settings()
	apply_brightness()

# Ця функція отримує посилання на CanvasModulate зі сцени
func set_brightness_layer(layer: CanvasModulate) -> void:
	brightness_layer = layer
	apply_brightness()

# Функція застосовує яскравість до сцени через CanvasModulate
func apply_brightness() -> void:
	if brightness_layer == null:
		return

	var b = game_data["brightness"]
	brightness_layer.color = Color(b, b, b, 1.0)
	
func apply_audio_settings() -> void:
	apply_master_volume()
	apply_music_volume()
	apply_sfx_volume()

# Застосування гучності головної шини Master.
func apply_master_volume() -> void:
	# Отримуємо індекс шини з назвою "Master"
	var bus_index = AudioServer.get_bus_index("Master")
	# Ставимо для цієї шини значення гучності із game_data
	AudioServer.set_bus_volume_db(bus_index, game_data["master_vol"])

func apply_music_volume() -> void:
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, game_data["music_vol"])
	
func apply_sfx_volume() -> void:
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, game_data["sfx_vol"])
	
func apply_resolution() -> void:
	# Беремо зі словника Vector2i(ширина, висота).
	var res = game_data["screen_resolution"]
	# Встановлюємо цей розмір для вікна гри
	DisplayServer.window_set_size(res)
	
func apply_display_mode() -> void:
	var mode = game_data["display_mode"]

	match mode:
		"windowed":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			apply_resolution()

		"windowed_fullscreen":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

		"fullscreen":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func apply_fps() -> void:
	var fps = game_data["max_fps"]
	Engine.max_fps = fps

# Функція для застосування відеоналаштувань,
# зокрема VSync та FPS
func apply_video_settings() -> void:
	# Якщо VSync увімкнений, то FPS буде синхронізовано з монітором
	if game_data["vsync_on"]:
		# Вмикаємо вертикальну синхронізацію
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	
	# Якщо VSync вимкнений, тоді працює ручне обмеження FPS
	else:
		# Вимикаємо вертикальну синхронізацію
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		# Обмежуємо FPS значенням зі словника
		Engine.max_fps = game_data["max_fps"]
		
# Не обов'язкова, але корисна допоміжна функція:
# повертає всі налаштування до дефолтних значень у пам'яті,
# але НЕ зберігає їх у файл.
func reset_to_defaults() -> void:
	game_data = get_default_settings().duplicate(true)
