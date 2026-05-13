extends Node

var unit_database : SQLite

func unit_choose_level_menu(level_id, curent_save):
	unit_database = SQLite.new()
	unit_database.path = "res://unit_testing/unit_data.db"
	unit_database.open_db()
	
	unit_database.query("""
        SELECT quality
        FROM saving
        WHERE level_id = %d AND save_id = %d;
	""" % [level_id, curent_save])
	
func unit_data_write(success_count, level_number, curent_save):
	
	unit_database = SQLite.new()
	unit_database.path = "res://unit_testing/unit_data.db"
	unit_database.open_db()
	
	unit_database.query("""
	SELECT *
	FROM saving
	WHERE level_id = %d
	and save_id = %d;
	""" % [level_number, curent_save])
	if unit_database.query_result.is_empty():
		unit_database.query("""INSERT into saving(level_id, save_id, quality) 
        VALUES (%d, %d, %d);
		""" % [level_number, curent_save, success_count])
	else:
		unit_database.query("""
			UPDATE saving
			SET quality = %d
			WHERE level_id = %d and save_id = %d and quality < %d;
		""" % [success_count, level_number, curent_save, success_count])
	unit_database.query("""
	SELECT quality
	FROM saving
	WHERE level_id = %d
	and save_id = %d;
	""" % [level_number, curent_save])
