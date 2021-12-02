extends Control

var columns := 2
var rows := 2
var num_grids := 0
var grid_container_array : Array
var current_page := 1

onready var grid_container := $MarginContainer
onready var scene_handler := get_parent()
onready var tween := $Tween

func _ready() -> void:
	$BackButton.connect("pressed", self, "_on_BackButton_pressed")
	$BackButton.connect("mouse_entered", self, "_on_BackButton_mouse_entered")
	$BackButton.connect("mouse_exited", self, "_on_BackButton_mouse_exited")
	$NextPage.connect("pressed", self, "_on_NextPage_pressed")
	$PrevPage.connect("pressed", self, "_on_PrevPage_pressed")
	
	for lev in range(GameData.levelArray.size()):
		if lev % (columns * rows) == 0:
			var grid := GridContainer.new()
			grid.columns = 2
			grid.add_constant_override("hseparation", 30)
			grid.add_constant_override("vseparation", 60)
			num_grids += 1
			grid.name = "GridContainer" + String(num_grids)
			grid_container.add_child(grid)
			grid_container_array.push_back(grid)
	
	for lev in GameData.levelArray:
		var level_button = load("res://scenes/UI/level_select/LevelSelectButton.tscn").instance()
		level_button.texture = load(GameData.levelDict[lev]["img"])
		level_button.level_path = GameData.levelDict[lev]["scene"]
		level_button.level_select_screen = self
		level_button.get_node("Label").text = lev
		
		var level_container: Node
		for gc in grid_container_array.size():
			if grid_container_array[gc].get_child_count() < 4:
				level_container = grid_container.get_node("GridContainer" + String(gc + 1))
				break
		
		level_container.add_child(level_button)
	
	if grid_container_array.size() > 1:
		for i in range(1, grid_container_array.size()):
			grid_container_array[i].visible = false
	
	$PrevPage.disabled = true


func update_pagination_button_state() -> void:
	if (current_page - 1) - 1 < 0:
		$PrevPage.disabled = true
	else:
		$PrevPage.disabled = false
	
	if current_page >= grid_container_array.size():
		$NextPage.disabled = true
	else:
		$NextPage.disabled = false
	
	grid_container_array[current_page - 1].visible = true


func _on_BackButton_pressed() -> void:
	var main_menu = load("res://scenes/UI/main_menu/MainMenu.tscn").instance()
	scene_handler.add_child(main_menu)
	scene_handler.connect_signals()
	queue_free()


func _on_BackButton_mouse_entered() -> void:
	tween.interpolate_property($BackButton, "rect_scale", $BackButton.rect_scale, Vector2(0.7, 0.7), 0.3, Tween.TRANS_SINE)
	tween.start()


func _on_BackButton_mouse_exited() -> void:
	tween.interpolate_property($BackButton, "rect_scale", $BackButton.rect_scale, Vector2(0.9, 0.9), 0.3, Tween.TRANS_SINE)
	tween.start()


func _on_NextPage_pressed() -> void:
	grid_container_array[current_page - 1].visible = false
	current_page += 1
	update_pagination_button_state()


func _on_PrevPage_pressed() -> void:
	grid_container_array[current_page - 1].visible = false
	current_page -= 1
	update_pagination_button_state()

















