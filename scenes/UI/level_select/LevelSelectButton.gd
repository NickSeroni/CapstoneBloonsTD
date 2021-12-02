extends TextureRect

var level_path : String
var level_select_screen: Control

var level_completed := false


func _ready():
	$Button.connect("pressed", self, "_on_Button_pressed")
	
	level_completed = GameData.levelDict[$Label.text]["completed"]
	$StarTextureRect.visible = level_completed


func _on_Button_pressed():
	var game_scene = load("res://GameScene.tscn").instance()
	var level = load(level_path).instance()
	game_scene.get_node("MapContainer").add_child(level)
	game_scene.current_map_name = $Label.text
	get_tree().root.get_node("SceneHandler").add_child(game_scene)
	level_select_screen.queue_free()

















