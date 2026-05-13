extends GutTest

var DatabaseManager = preload("res://unit_testing/unit_database_manager.gd")

func test_unit_choose_level_menu():
	var datamanager = DatabaseManager.new()
	
	var level_id = 1
	var curent_save = 1
	
	datamanager.unit_choose_level_menu(level_id, curent_save)
	
	assert_eq(datamanager.unit_database.query_result[0]["quality"], 1)

func test_unit_data_write():
	var datamanager = DatabaseManager.new()
	
	var level_id = 2
	var curent_save = 1
	var success_count = 3
	
	datamanager.unit_data_write(success_count, level_id, curent_save)
	
	assert_eq(datamanager.unit_database.query_result[0]["quality"], 3)
	
	success_count = 2
	
	
	datamanager.unit_data_write(success_count, level_id, curent_save)
	
	assert_eq(datamanager.unit_database.query_result[0]["quality"], 3)
	
