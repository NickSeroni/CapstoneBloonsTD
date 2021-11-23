extends Node


func _ready():
	connect_signals()


func connect_signals():
	$MainMenu/MarginContainer/VBox/PlayButton.connect("pressed", self, "_on_PlayButton_pressed")
	$MainMenu/MarginContainer/VBox/Quit.connect("pressed", self, "_on_Quit_pressed")


func _on_PlayButton_pressed() -> void:
	$MainMenu.queue_free()
	var level_select = load("res://scenes/UI/level_select/LevelSelect.tscn").instance()
	add_child(level_select)


func _on_Quit_pressed() -> void:
	SaveHandler.save_and_quit()
