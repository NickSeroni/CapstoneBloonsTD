extends Node2D

signal wave_updated(count)
signal lives_updated(count)
signal money_updated(count)

var balloon := load("res://scenes/balloons/Balloon.tscn")

var map_node : Node2D
var balloon_path_area : Area2D

var build_mode := false
var build_valid := false
var build_location: Vector2
var build_type : String

var current_wave := 0
var balloons_in_wave := 0

var money := 250
var lives := 100


func _ready() -> void:
	map_node = $MapContainer.get_child(0)
	balloon_path_area = map_node.get_node("BalloonPathArea")
	
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("pressed", self, "initiate_build_mode", [i.get_name()])
	
	start_next_wave()


func _process(delta: float) -> void:
	if build_mode:
		update_tower_preview()


# Catches input not caught by UI already
func _unhandled_input(event) -> void:
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
	
	if event.is_action_released("toggle_ui_visible"):
		$UI/HUD.set_visible(!$UI/HUD.visible)
	
	if event.is_action_pressed("ui_cancel") and build_mode == false:
		get_tree().paused = true
		var pause_menu = load("res://scenes/UI/pause_menu/PauseMenu.tscn").instance()
		$UI.add_child(pause_menu)


func initiate_build_mode(tower_type: String) -> void:
	if build_mode:
		cancel_build_mode()
	
	build_type = tower_type + "T1"
	build_mode = true
	
	# Disable all build buttons until tower is built or action cancelled
	$UI.set_tower_preview(build_type, get_global_mouse_position())


func update_tower_preview() -> void:
	var mouse_position = get_global_mouse_position()
	$UI.update_tower_preview_pos(mouse_position)
	
	var tower_overlap := $UI.get_node("TowerPreview").get_child(0).get_node("OverlapArea")
	if tower_overlap.get_overlapping_areas().empty():
		$UI.update_tower_preview_color("ad54ff3c") # green
		build_valid = true
		build_location = mouse_position
	else:
		$UI.update_tower_preview_color("adff4545") # red
		build_valid = false


func cancel_build_mode() -> void:
	#print("Build cancelled")
	build_mode = false
	build_valid = false
	get_node("UI/TowerPreview").free()


func verify_and_build() -> void:
	if build_valid:
		# Check if player has enough money
		
		var new_tower = load("res://scenes/towers/" + build_type + ".tscn").instance()
		new_tower.position = build_location
		new_tower.name += "_"
		map_node.get_node("Towers").add_child(new_tower, true)
		
		# Deduct money
		# Update money label
		
		# Cancel build mode only after tower is placed or manually cancelled
		cancel_build_mode()


func start_next_wave() -> void:
	var wave_data = retrieve_wave_data()
	# Padding between waves
	yield(get_tree().create_timer(0.2), "timeout")
	spawn_balloons(wave_data)


func retrieve_wave_data() -> Array:
	var wave_data = [["Red", 0.7], ["Red", 0.1],["Red", 0.7], ["Blue", 0.1],["Blue", 0.7], ["Red", 0.1]]
	current_wave += 1
	emit_signal("wave_updated", current_wave)
	balloons_in_wave = wave_data.size()
	return wave_data


func spawn_balloons(wave_data: Array) -> void:
	for i in wave_data:
		var new_balloon = balloon.instance()
		new_balloon.type = i[0]
		new_balloon.connect("end_reached", self, "_on_balloon_end_reached")
		map_node.get_node("BalloonPath").add_child(new_balloon, true)
		yield(get_tree().create_timer(i[1]), "timeout")


func _on_balloon_end_reached():
	lives -= 1
	emit_signal("lives_updated", lives)


func _on_PausePlayButton_toggled(button_pressed: bool):
	# Pause the balloons
	if button_pressed:
		var play_icon = load("res://Assets/UI/icons/Game icons (base)/PNG/White/1x/forward.png")
		$UI/HUD/SpeedControls/PausePlayButton.icon = play_icon
		get_tree().paused = button_pressed
	# Resume the balloons
	else:
		var pause_icon = load("res://Assets/UI/icons/Game icons (base)/PNG/White/1x/pause.png")
		$UI/HUD/SpeedControls/PausePlayButton.icon = pause_icon
		get_tree().paused = button_pressed


func _on_FastButton_toggled(button_pressed: bool):
	pass















