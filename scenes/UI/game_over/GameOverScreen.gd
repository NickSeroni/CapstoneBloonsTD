extends Control


var is_loss := false

func _ready() -> void:
	$Panel/VBoxContainer/Button.connect("pressed", self, "_on_ExitToMainButton_pressed")
	$Panel/VBoxContainer/Button2.connect("pressed", self, "_on_QuitButton_pressed")
	
	get_tree().paused = true
	
	if is_loss:
		$Panel/MarginContainer/CenterContainer/Label.text = "Game Over"
	else:
		$Panel/MarginContainer/CenterContainer/Label.text = "You win!"


func _on_ExitToMainButton_pressed():
	var main_menu = load("res://scenes/UI/main_menu/MainMenu.tscn").instance()
	var scene_handler = get_tree().root.get_node("SceneHandler")
	scene_handler.get_node("GameScene").queue_free()
	scene_handler.add_child(main_menu)
	scene_handler.connect_signals()
	get_tree().paused = false
	queue_free()


func _on_QuitButton_pressed():
	SaveHandler.save_and_quit()
