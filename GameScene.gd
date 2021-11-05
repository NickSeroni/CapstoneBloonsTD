extends Node2D

signal round_updated(count)
signal lives_updated(count)
signal money_updated(count)

var balloon := preload("res://scenes/balloons/Balloon.tscn")

var map_node : Node2D
var balloon_path_area : Area2D

var build_mode := false
var build_valid := false
var build_location: Vector2
var build_type : String

var current_round := 0
var is_round_ended := true

var lives := 100
var money := 300


func _ready() -> void:
	emit_signal("lives_updated", lives)
	emit_signal("money_updated", money)
	emit_signal("round_updated", current_round)
	
	map_node = $MapContainer.get_child(0)
	balloon_path_area = map_node.get_node("BalloonPathArea")
	
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("pressed", self, "initiate_build_mode", [i.get_name()])


func _process(delta: float) -> void:
	if build_mode:
		update_tower_preview()


# Catches input not caught by UI already
func _unhandled_input(event) -> void:
	if event.is_action_released("build_cancel") and build_mode == true:
		cancel_build_mode()
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
	
	if event.is_action_released("toggle_ui_visible"):
		$UI/HUD.set_visible(!$UI/HUD.visible)


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
		if GameData.tower_data[build_type]["price"] <= money:
			var new_tower = load("res://scenes/towers/" + build_type + ".tscn").instance()
			new_tower.position = build_location
			new_tower.built = true
			new_tower.type = build_type
			new_tower.name += "_"
			map_node.get_node("Towers").add_child(new_tower, true)
			
			# Deduct money
			# Update money label
			money -= GameData.tower_data[build_type]["price"]
			emit_signal("money_updated", money)
			
			# Cancel build mode only after tower is placed or manually cancelled
			cancel_build_mode()
		else:
			print("not enough money")


# Next round should start when all balloons are popped from previous round
func start_next_round() -> void:
	current_round += 1
	emit_signal("round_updated", current_round)
	var new_round = Round.new(current_round)
	# Padding between rounds
	yield(get_tree().create_timer(1), "timeout")
	spawn_balloons(new_round.wave_array)


func spawn_balloons(wave_data: Array) -> void:
	# loop through every wave, then spawn a balloon for each count
	var c := 0
	for i in wave_data:
		c += 1
		for _w in range(i["count"]):
			var new_balloon = balloon.instance()
			new_balloon.type = i["type"]
			connect_balloon_signals(new_balloon)
			map_node.get_node("BalloonPath").add_child(new_balloon, true)
			yield(get_tree().create_timer(0.5), "timeout") # spawn time padding


func connect_balloon_signals(b: Balloon):
	b.connect("end_reached", self, "_on_balloon_end_reached")
	b.connect("popped", self, "_on_balloon_poppped")
	b.connect("child_spawned", self, "_on_BalloonChildSpawned")


# check if all balloons are freed from the level 
# either by popping or reaching the end to start the next round
func check_balloons_cleared():
	yield(get_tree(), "idle_frame")
	if $MapContainer.get_child(0).get_node("BalloonPath").get_children().empty():
		start_next_round()


func _on_balloon_end_reached(damage: int):
	lives -= damage
	emit_signal("lives_updated", lives)
	check_balloons_cleared()


func _on_balloon_poppped(value):
	money += value
	emit_signal("money_updated", money)
	check_balloons_cleared()


func _on_BalloonChildSpawned(balloon: WeakRef):
	connect_balloon_signals(balloon.get_ref())










