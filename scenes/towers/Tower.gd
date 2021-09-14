extends Node2D

onready var shoot_positions := get_node("Turret/ShootPositions")
onready var fire_radius_area := get_node("FireRadius")
onready var time_active := Timer.new()
onready var fire_rate_timer := Timer.new()
onready var range_texture : Sprite

var type   : String
var damage : int
var rof    : float
var radius : int
var splash : bool
var shot_type : String
var bullet_speed : int

# Combat
var targets : Array
var target
var bullet
var shoot_position_array : Array
# UI
var is_ui_active := false
var pop_count : int


func _ready() -> void:
	get_node("OverlapArea").connect("input_event", self, "_on_OverlapArea_input_event")
	fire_radius_area.connect("area_entered", self, "_on_FireRadius_area_entered")
	fire_radius_area.connect("area_exited", self, "_on_FireRadius_area_exited")
	
	# Initialize the object variables based on hardcoded meta data
	type = name.substr(0, name.find("_"))
	damage = GameData.tower_data[type]["damage"]
	rof = GameData.tower_data[type]["rof"]
	radius = GameData.tower_data[type]["radius"]
	splash = GameData.tower_data[type]["splash"]
	shot_type = GameData.tower_data[type]["bullet"]
	bullet_speed = GameData.tower_data[type]["bullet_speed"]
	
	bullet = load(shot_type)
	shoot_position_array = shoot_positions.get_children()
	
	# Set the fire radius size and add the texture as a child
	fire_radius_area.get_child(0).shape.radius = radius
	print(fire_radius_area.get_child(0).shape.radius)
	range_texture = Sprite.new()
	range_texture.position = Vector2.ZERO
	var scaling = radius / 256.0
	range_texture.scale = Vector2(scaling, scaling)
	var texture = load("res://Assets/UI/range_indicator.png")
	range_texture.texture = texture
	add_child(range_texture)
	range_texture.hide()
	
	# Create and add a RateOfFire Timer node
	fire_rate_timer.connect("timeout", self, "_on_FireRateTimer_timeout")
	add_child(fire_rate_timer)
	
	# Makes sure the tower UI doesnt activate when spawned in on click
	time_active.set_one_shot(true)
	time_active.set_wait_time(0.1)
	time_active.set_autostart(true)
	add_child(time_active)


func _draw():
	if targets.size() > 0:
		draw_line(global_position, target.global_position, Color(255, 0, 0))


func _physics_process(delta: float) -> void:
	acquire_target()
	turn()


func acquire_target():
	if targets.size() > 0:
		target = get_farthest_balloon()
		if fire_rate_timer.is_stopped():
			shoot()
			fire_rate_timer.start(rof)
	else:
		target = null
		if !fire_rate_timer.is_stopped():
			fire_rate_timer.stop()


func turn() -> void:
	if target:
		var enemy_position = target.get_global_position()
		var curr_rot = $Turret.get_rotation()
		$Turret.rotation = lerp_angle(curr_rot, enemy_position.angle_to_point(position) + (PI * 0.5), 0.2)


# Returns the balloon farthest along the track
func get_farthest_balloon() -> PathFollow2D:
	var retval : PathFollow2D
	var highest := 0
	for t in targets:
		if t.get_offset() > highest:
			highest = t.get_offset()
			retval = t
	
	return retval

# Enables tower GUI on mouse click
func _on_OverlapArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_released("select") and time_active.is_stopped():
		if is_ui_active == false:
			is_ui_active = true
			range_texture.show()
		else:
			is_ui_active = false
			range_texture.hide()


func _on_FireRadius_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("balloons"):
		var balloon = area.get_parent()
		#print(balloon.name + " entered")
		
		targets.push_back(balloon)


func _on_FireRadius_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("balloons"):
		var balloon = area.get_parent()
		#print(balloon.name + " exited")
		
		targets.erase(balloon)


func shoot() -> void:
	var bullet_instance = bullet.instance()
	bullet_instance.set_target(target)
	bullet_instance.speed = bullet_speed
	bullet_instance.transform = shoot_position_array[0].global_transform
	bullet_instance.rotation = $Turret.rotation
	get_tree().get_root().get_node("SceneHandler/GameScene/BulletContainer").add_child(bullet_instance)
	
	print(name + " shot at " + target.name)


# Each timeout is one shot fired
func _on_FireRateTimer_timeout() -> void:
	shoot()



























