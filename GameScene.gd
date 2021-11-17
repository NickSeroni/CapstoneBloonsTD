extends Node2D

signal round_updated(count)
signal lives_updated(count)
signal money_updated(count)

const balloon := preload("res://scenes/balloons/Balloon.tscn")

var build_mode := false
var build_valid := false
var build_location: Vector2
var build_type : String

var current_round := 0
var is_round_ended := true
var current_round_balloons_popped := 0
# total balloon damage to be checked against balloons popped
var current_round_balloon_total := 0

var lives := 100
var money := 400

var game_over := false

onready var map_node : Node2D
onready var balloon_path_area : Area2D

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
	
	build_type = tower_type + "1"
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
			var new_tower: Tower = load("res://scenes/towers/" + build_type + ".tscn").instance()
			new_tower.position = build_location
			new_tower.built = true
			new_tower.type = build_type
			new_tower.name += "_"
			new_tower.connect("tower_clicked", self, "_on_TowerClicked")
			new_tower.connect("stats_changed", self, "_on_Tower_stats_changed")
			map_node.get_node("Towers").add_child(new_tower, true)
			
			# Deduct money
			# Update money label
			add_money(-1 * new_tower.price)
			
			# Cancel build mode only after tower is placed or manually cancelled
			cancel_build_mode()
		else:
			print("not enough money")


# Next round should start when all balloons are popped from previous round
func start_next_round() -> void:
	current_round += 1
	emit_signal("round_updated", current_round)
	var new_round = Round.new(current_round)
	
	current_round_balloon_total = 0
	current_round_balloons_popped = 0
	
	# calculate total poppage necessary to advance to next round
	if GameData.wave_data.has(current_round):
		for i in GameData.wave_data[current_round]:
			# ex. red -> total += 1, green -> total += 3 etc.
			current_round_balloon_total += (i["count"] * GameData.balloon_data[i["type"]]["damage"])
	print("----------------Round " + String(current_round) + " ----------------------")
	print(current_round_balloon_total)
	
	# Padding between rounds
	yield(get_tree().create_timer(1), "timeout")
	spawn_balloons(new_round.wave_array)


func spawn_balloons(wave_data: Array) -> void:
	# loop through every wave, then spawn a balloon for each count
	for i in wave_data:
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
	
	print(String(current_round_balloons_popped) + " / " + String(current_round_balloon_total))
	
	if current_round_balloons_popped >= current_round_balloon_total:
		if GameData.wave_data.has(current_round + 1):
			start_next_round()
		else:
			if !game_over:
				win()


func add_money(value: int) -> void:
	money += value
	emit_signal("money_updated", money)


func win() -> void:
	print("You win!")
	var game_over_screen = load("res://scenes/UI/game_over/GameOverScreen.tscn").instance()
	$UI.add_child(game_over_screen)
	game_over = true


func lose() -> void:
	print("You lose!")
	game_over = true


func _on_balloon_end_reached(damage: int):
	lives -= damage
	emit_signal("lives_updated", lives)
	current_round_balloons_popped += damage
	check_balloons_cleared()


func _on_balloon_poppped(value):
	add_money(value)
	current_round_balloons_popped += 1
	check_balloons_cleared()


func _on_BalloonChildSpawned(balloon: WeakRef):
	connect_balloon_signals(balloon.get_ref())


# Recieves the tower that has been clicked
# Sets the tower UI based on that tower's stats
func _on_TowerClicked(t: Tower) -> void:
	if t == $UI.current_tower and $UI/HUD/TowerStats.visible:
		$UI/HUD/TowerStats.visible = false
		t.range_texture.hide()
		$UI.current_tower = null
	else:
		$UI/HUD/TowerStats.visible = true
		if $UI.current_tower:
			$UI.current_tower.range_texture.hide()
		t.range_texture.show()
		$UI.update_tower_stats(t)


func _on_Tower_stats_changed(t: Tower) -> void:
	if $UI/HUD/TowerStats.visible && $UI.current_tower == t:
		$UI.update_tower_stats(t)




