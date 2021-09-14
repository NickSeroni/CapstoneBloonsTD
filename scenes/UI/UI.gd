extends CanvasLayer


func _ready():
	get_parent().connect("wave_updated", self, "_on_wave_updated")
	get_parent().connect("lives_updated", self, "_on_lives_updated")


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


func _on_wave_updated(new_wave_number):
	$HUD/WaveLabel/Number.text = String(new_wave_number)


func _on_lives_updated(count):
	$HUD/HealthLabel.text = String(count)











