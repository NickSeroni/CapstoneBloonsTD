extends Node

const FILE_NAME = "user://save.save"

func _ready() -> void:
	load_data()


func _notification(what: int) -> void:
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		save_and_quit()


# only saving the level dictionary
func save_data() -> void:
	var save_dict = GameData.levelDict
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(save_dict))
	file.close()


func load_data() -> void:
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			GameData.levelDict = data
		else:
			printerr("Corrupt data load!")
	else:
		print("No saved data")
	file.close()


func save_and_quit():
	print("Saving data")
	save_data()
	get_tree().quit()


func reset_data() -> void:
	for level in GameData.levelArray:
		GameData.levelDict[level]["completed"] = false
	save_data()
