extends Node


func _ready():
	$MainMenu/MarginContainer/VBox/PlayButton.connect("pressed", self, "_on_PlayButton_pressed")
	$MainMenu/MarginContainer/VBox/Quit.connect("pressed", self, "_on_Quit_pressed")
	$MainMenu/AnimationPlayer.play("buttons")


func _on_PlayButton_pressed() -> void:
	$MainMenu.queue_free()
	var game_scene = load("res://GameScene.tscn").instance()
	add_child(game_scene)


func _on_Quit_pressed() -> void:
	get_tree().quit()
