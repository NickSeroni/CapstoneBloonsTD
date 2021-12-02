# This is pause menu. While this is on the screen, the game will be paused
# except for this scene, which will continue processing.
# The game is unpaused when the menu is closed
class_name PauseMenu
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
	
	$CenterContainer/ColorRect/VBoxContainer/ExitToMainButton.connect("pressed", self, "_on_ExitToMainButton_pressed")
	
	$CenterContainer/ColorRect/VBoxContainer/QuitButton.connect("pressed", self, "_on_QuitButton_pressed")
	
	$CenterContainer/ColorRect/VBoxContainer/VolumeHSlider.connect("value_changed", self, "_on_VolumeSlider_value_changed")
	$CenterContainer/ColorRect/VBoxContainer/VolumeHSlider/MuteCheckBox.connect("toggled", self, "_on_MuteButton_toggled")
	
	hide()


func _input(event):
	if event.is_action_pressed("ui_cancel") and visible:
		get_tree().set_input_as_handled()
		if get_parent().is_pause_button_active:
			get_tree().paused = false
		
		hide()


func _on_CloseMenuButton_button_down():
	close_menu_button.rect_scale = Vector2(0.9, 0.9)
	close_menu_button.modulate = Color(CLOSE_MENU_BUTTON_DOWN_COLOR)


func _on_CloseMenuButton_button_up():
	close_menu_button.rect_scale = Vector2(1, 1)
	close_menu_button.modulate = Color(CLOSE_MENU_BUTTON_OG_COLOR)
	
	if get_tree().paused == true:
		get_tree().paused = false
	
	hide()


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


func _on_VolumeSlider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


func _on_MuteButton_toggled(button_pressed: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), button_pressed)














