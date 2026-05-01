extends Node

var database : SQLite
var curent_save : int

func _ready() -> void:
	database = SQLite.new()
	database.path = "user://data.db"
	database.open_db()
	
	_create_tables()
	_seed_data()


func _create_tables():
	# level
	database.query("""
		CREATE TABLE IF NOT EXISTS level (
			level_id INTEGER PRIMARY KEY,
			metadat TEXT
		);
	""")
	
	# save
	database.query("""
		CREATE TABLE IF NOT EXISTS save (
			save_id INTEGER PRIMARY KEY,
			metadata TEXT
		);
	""")
	
	# saving (зв'язуюча таблиця)
	database.query("""
		CREATE TABLE IF NOT EXISTS saving (
			level_id INTEGER,
			save_id INTEGER,
			quality INTEGER,
			PRIMARY KEY (level_id, save_id),
			FOREIGN KEY (level_id) REFERENCES level(level_id),
			FOREIGN KEY (save_id) REFERENCES save(save_id)
		);
	""")


func _seed_data():
	# перевіряємо чи таблиця level порожня
	database.query("SELECT COUNT(*) as count FROM level;")
	var result = database.query_result
	
	if result.size() > 0 and result[0]["count"] == 0:
		# заповнюємо рівні
		for i in range(1, 4):
			database.query("INSERT INTO level (level_id, metadat) VALUES (%d, NULL);" % i)
	
	# перевірка save
	database.query("SELECT COUNT(*) as count FROM save;")
	result = database.query_result
	
	if result.size() > 0 and result[0]["count"] == 0:
		for i in range(1, 4):
			database.query("INSERT INTO save (save_id, metadata) VALUES (%d, NULL);" % i)
