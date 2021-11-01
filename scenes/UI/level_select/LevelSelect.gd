extends Control

onready var grid_container := $MarginContainer
onready var scene_handler := get_parent()

var columns := 2
var rows := 2
var num_grids := 0


func _ready() -> void:
	$BackButton.connect("pressed", self, "_on_BackButton_pressed")
	
	for lev in range(GameData.levelArray.size()):
		if lev % (columns * rows) == 0:
			var grid := GridContainer.new()
			grid.columns = 2
			grid.add_constant_override("hseparation", 30)
			grid.add_constant_override("vseparation", 60)
			num_grids += 1
			grid.name = "GridContainer" + String(num_grids)
			grid_container.add_child(grid)
	
	for lev in GameData.levelArray:
		var level_button = load("res://scenes/UI/level_select/LevelSelectButton.tscn").instance()
		level_button.texture = load(GameData.levelDict[lev]["img"])
		level_button.level_path = GameData.levelDict[lev]["scene"]
		level_button.level_select_screen = self
		level_button.get_node("Label").text = lev
		
		var level_container = grid_container.get_node("GridContainer" + String(num_grids))
		level_container.add_child(level_button)


func _on_BackButton_pressed() -> void:
	var main_menu = load("res://scenes/UI/main_menu/MainMenu.tscn").instance()
	scene_handler.add_child(main_menu)
	scene_handler.connect_signals()
	queue_free()
