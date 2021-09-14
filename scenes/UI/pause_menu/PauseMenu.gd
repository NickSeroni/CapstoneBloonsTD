# This is pause menu. While this is on the screen, the game will be paused
# except for this scene, which will continue processing.
# The game is unpaused when the menu is closed
extends Control

var audio_enabled_icon = preload("res://Assets/UI/icons/Game icons (base)/PNG/White/1x/audioOn.png")
var audio_disabled_icon = preload("res://Assets/UI/icons/Game icons (base)/PNG/White/1x/audioOff.png")

onready var close_menu_button := $CenterContainer/ColorRect/CloseMenuButton
onready var volume_slider := $CenterContainer/ColorRect/VBoxContainer/VolumeHSlider

const CLOSE_MENU_BUTTON_OG_COLOR := "#d94e4e"
const CLOSE_MENU_BUTTON_DOWN_COLOR := "#dc8484"

func _ready():
	close_menu_button.connect("button_down", self, "_on_CloseMenuButton_button_down")
	close_menu_button.connect("button_up", self, "_on_CloseMenuButton_button_up")
	
	$CenterContainer/ColorRect/VBoxContainer/QuitButton.connect("pressed", self, "_on_QuitButton_pressed")


func _input(event):
	if event.is_action_pressed("ui_cancel") && get_tree().paused == true:
		get_tree().set_input_as_handled()
		get_tree().paused = false
		queue_free()


func _on_CloseMenuButton_button_down():
	close_menu_button.rect_scale = Vector2(0.9, 0.9)
	close_menu_button.modulate = Color(CLOSE_MENU_BUTTON_DOWN_COLOR)


func _on_CloseMenuButton_button_up():
	close_menu_button.rect_scale = Vector2(1, 1)
	close_menu_button.modulate = Color(CLOSE_MENU_BUTTON_OG_COLOR)
	
	if get_tree().paused == true:
		get_tree().paused = false
	
	queue_free()


func _on_QuitButton_pressed():
	print("quit pressed")
	get_tree().quit()
