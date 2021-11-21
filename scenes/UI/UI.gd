extends CanvasLayer

var is_pause_button_active := false
var is_tower_ui_active := false

onready var current_tower: Tower

onready var tower_stats := $HUD/TowerStats
onready var type_label := tower_stats.get_node("TypeLabel")
onready var tier_label := tower_stats.get_node("TierLabel")
onready var rof_label := tower_stats.get_node("VBoxContainer3/ROFLabel")
onready var pen_label := tower_stats.get_node("VBoxContainer3/PenLabel")
onready var pops_label := tower_stats.get_node("VBoxContainer3/PopCountLabel")
onready var upgrade_price_label := tower_stats.get_node("PricesContainer/UpgradePriceLabel")
onready var sell_price_label := tower_stats.get_node("PricesContainer/SellPriceLabel")
onready var upgrade_button := tower_stats.get_node("ButtonContainer/UpgradeButton")
onready var sell_button := tower_stats.get_node("ButtonContainer/SellButton")


func _ready():
	get_parent().connect("round_updated", self, "_on_round_updated")
	get_parent().connect("lives_updated", self, "_on_lives_updated")
	get_parent().connect("money_updated", self, "_on_money_updated")
	
	sell_button.connect("pressed", self, "_on_SellButton_pressed")
	
	#$HUD/TowerStats.visible = false


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") && !get_parent().build_mode:
		var pause_menu = load("res://scenes/UI/pause_menu/PauseMenu.tscn").instance()
		add_child(pause_menu)
		toggle_pause()


func set_tower_preview(tower_type: String, mouse_position) -> void:
	# Set the turret textures
	var drag_tower = load("res://scenes/towers/" + tower_type + ".tscn").instance()
	drag_tower.set_name("DragTower")
	drag_tower.set_rotation_degrees(90)
	# Nullify the script to avoid unexpected behaviors
	drag_tower.script = null
	# Modulate to a slightly transparent green
	drag_tower.modulate = Color("ad54ff3c")
	
	var range_texture = Sprite.new()
	range_texture.position = Vector2.ZERO
	var scaling = GameData.tower_data[tower_type]["radius"] / 256.0
	range_texture.scale = Vector2(scaling, scaling)
	var texture = load("res://Assets/UI/range_indicator.png")
	range_texture.texture = texture
	range_texture.modulate = Color("ad54ff3c")
	
	# Add the drag_tower as a child of this new control node
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.add_child(range_texture, true)
	control.rect_position = mouse_position
	control.set_name("TowerPreview")
	add_child(control, true)
	move_child(get_node("TowerPreview"), 0)


func update_tower_preview_pos(new_position: Vector2) -> void:
	get_node("TowerPreview").rect_position = new_position


func update_tower_preview_color(color: String) -> void:
	if get_node("TowerPreview/DragTower").modulate != Color(color):
		get_node("TowerPreview/DragTower").modulate = Color(color)
		get_node("TowerPreview/Sprite").modulate = Color(color)


func toggle_pause():
	if is_pause_button_active:
		get_tree().paused = true


# If tower UI is active, then that tower should show its radius
# and the stats should show that tower's stats
# if another tower is clicked while the tower stats are open then
# the previous tower's radius disappears and the new tower's appears
# and the stats reflects the new tower's stats

# Called from GameScene when a tower is clicked or the tower's stats are updated
# while the UI is active
func update_tower_stats(t: Tower) -> void:
	current_tower = t
	
	print(t.pop_count)
	
	type_label.text = t.type.substr(0, t.type.length() - 1)
	tier_label.text = "Tier " + String(t.tier)
	rof_label.text = "ROF: " + String(t.rof)
	pen_label.text = "Pen: " + String(t.bullet_pen)
	pops_label.text = "Pops: " + String(t.pop_count)
	upgrade_price_label.text = "$" + String(t.price)
	sell_price_label.text = "$" + String(t.sell_price)


func _on_round_updated(new_round_number):
	$HUD/RoundLabel/Number.text = String(new_round_number)


func _on_lives_updated(count):
	$HUD/HMGridContainer/HealthLabel.text = String(count)


func _on_money_updated(count):
	#print("money: " + String(count))
	$HUD/HMGridContainer/MoneyLabel.text = String(count)


func _on_PausePlayButton_toggled(button_pressed: bool):
	if button_pressed:
		var pause_icon = load("res://assets/UI/icons/Game icons (base)/PNG/White/1x/pause.png")
		$HUD/SpeedControls/PausePlayButton.icon = pause_icon
		is_pause_button_active = true
		get_tree().paused = false
		
		if get_parent().current_round == 0:
			get_parent().start_next_round()
	else:
		# paused
		var play_icon = load("res://assets/UI/icons/Game icons (base)/PNG/White/1x/forward.png")
		$HUD/SpeedControls/PausePlayButton.icon = play_icon
		is_pause_button_active = false
		get_tree().paused = true


func _on_FastButton_toggled(button_pressed):
	if button_pressed:
		Engine.set_time_scale(2.0)
		$HUD/SpeedControls/FastButton.modulate = Color.white
	else:
		Engine.set_time_scale(1.0)
		$HUD/SpeedControls/FastButton.modulate = Color("646464")


func _on_SellButton_pressed() -> void:
	get_parent().add_money(current_tower.sell_price)
	yield(get_tree(), "idle_frame")
	current_tower.call_deferred("queue_free")
	current_tower = null
	tower_stats.visible = false
















