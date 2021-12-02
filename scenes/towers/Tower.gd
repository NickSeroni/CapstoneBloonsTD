class_name Tower
extends Node2D

signal tower_clicked(tower)
signal stats_changed(tower)

var type   : String
var tier   : int
var rof    : float
var radius : int
var price  : int
var sell_price : int
var splash : bool
var shot_type : String
var bullet_speed : int
var bullet_pen: int

var next_upgrade_price: int
var next_tier_available := true

var built : bool

# Combat
var targets_array : Array
var target = null
var bullet
var shoot_position_array : Array
var can_shoot := true
# UI
var pop_count : int

onready var shoot_positions := get_node("Turret/ShootPositions")
onready var fire_radius_area :Area2D = get_node("FireRadius")
onready var time_active := Timer.new()
onready var fire_rate_timer := Timer.new()
onready var range_texture : Sprite


func _ready() -> void:
	get_node("OverlapArea").connect("input_event", self, "_on_OverlapArea_input_event")
	fire_radius_area.connect("area_entered", self, "_on_FireRadius_area_entered")
	fire_radius_area.connect("area_exited", self, "_on_FireRadius_area_exited")
	
	# Initialize the object variables based on hardcoded meta data
	rof = GameData.tower_data[type]["rof"]
	radius = GameData.tower_data[type]["radius"]
	price = GameData.tower_data[type]["price"]
	sell_price = price / 4
	splash = GameData.tower_data[type]["splash"]
	shot_type = GameData.tower_data[type]["bullet"]
	bullet_speed = GameData.tower_data[type]["bullet_speed"]
	bullet_pen = GameData.tower_data[type]["pen"]
	tier = GameData.tower_data[type]["tier"]
	print(tier)
	
	if GameData.tower_tiers[type].has(tier + 1):
		next_upgrade_price = GameData.tower_tiers[type][tier + 1]["price"]
	
	if shot_type != "":
		bullet = load(shot_type)
	# Where the bullets spawn from
	shoot_position_array = shoot_positions.get_children()
	
	# Set the fire radius size and add the texture as a child
	fire_radius_area.get_child(0).shape.radius = radius
	#print(fire_radius_area.get_child(0).shape.radius)
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
	fire_rate_timer.wait_time = rof
	add_child(fire_rate_timer)
	
	# Makes sure the tower UI doesnt activate when spawned in on click
	time_active.set_one_shot(true)
	time_active.set_wait_time(0.1)
	time_active.set_autostart(true)
	add_child(time_active)


func _physics_process(delta: float) -> void:
	if targets_array.size() > 0 && built:
		acquire_target()
		if can_shoot:
			turn()
			shoot()
	else:
		target = null


func acquire_target():
	target = get_farthest_balloon()


func turn() -> void:
	if target != null:
		var enemy_position = target.get_global_position()
		$Turret.rotation = enemy_position.angle_to_point(position)


# Returns the balloon farthest along the track
func get_farthest_balloon() -> PathFollow2D:
	var retval : PathFollow2D
	var highest := 0
	for t in targets_array:
		if t.get_offset() > highest:
			highest = t.get_offset()
			retval = t
	return retval


func shoot() -> void:
	var bullet_instance: Bullet = bullet.instance()
	bullet_instance.pen = bullet_pen
	bullet_instance.set_target(target)
	bullet_instance.speed = bullet_speed
	bullet_instance.transform = shoot_position_array[0].global_transform
	bullet_instance.rotation = $Turret.global_rotation
	bullet_instance.parent = self
	get_tree().get_root().get_node("SceneHandler/GameScene/BulletContainer").add_child(bullet_instance)
	
	can_shoot = false
	fire_rate_timer.start()
	
	#print(name + " shot at " + target.name)


func upgrade() -> void:
	if GameData.tower_tiers.has(type):
		if GameData.tower_tiers[type].has(tier + 1):
			tier += 1
			
			var data = GameData.tower_tiers[type][tier]
			
			rof = data["rof"]
			fire_rate_timer.wait_time = rof
			radius = data["radius"]
			sell_price += (data["price"] - 50)
			bullet_pen = data["pen"]
			
			var scaling = radius / 256.0
			range_texture.scale = Vector2(scaling, scaling)
			
			fire_radius_area.get_node("CollisionShape2D").shape.radius = radius
			
			if !GameData.tower_tiers[type].has(tier + 1):
				next_tier_available = false
			
			emit_signal("stats_changed", self)
			
		else:
			next_tier_available = false
	else:
		next_tier_available = false


# Enables tower GUI on mouse click
func _on_OverlapArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_released("select") and time_active.is_stopped():
		emit_signal("tower_clicked", self)


func _on_FireRadius_area_entered(area: Area2D) -> void:
	if area.get_parent() is Balloon:
		var balloon = area.get_parent()
		#print(balloon.name + " entered")
		
		targets_array.push_back(balloon)


func _on_FireRadius_area_exited(area: Area2D) -> void:
	if area.get_parent() is Balloon:
		var balloon = area.get_parent()
		#print(balloon.name + " exited")
		
		targets_array.erase(balloon)


# Each timeout is one shot fired
func _on_FireRateTimer_timeout() -> void:
	can_shoot = true





















