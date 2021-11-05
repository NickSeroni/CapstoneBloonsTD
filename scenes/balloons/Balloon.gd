class_name Balloon
extends PathFollow2D

signal end_reached(damage)
signal popped
signal child_spawned(balloon)

var path: Node
var path_points: Array
var path_index := 0
var lead: PathFollow2D

var type: String
var color
var speed: int
var value: int
var damage: int

var child_type: String
var is_child := false

func _ready() -> void:
	add_to_group(Groups.BALLOONS)
	
	color = GameData.balloon_data[type]["color"]
	speed = GameData.balloon_data[type]["speed"]
	value = GameData.balloon_data[type]["value"]
	damage = GameData.balloon_data[type]["damage"]
	
	if GameData.balloon_data[type].has("child"):
		child_type = GameData.balloon_data[type]["child"]
	else:
		child_type = ""
	
	if is_child:
		var child_enable_timer : Timer = Timer.new()
		child_enable_timer.connect("timeout", self, "_on_ChildSpawnEnablePeriodTimer_timeout")
		child_enable_timer.one_shot = true
		child_enable_timer.wait_time = 0.1
		add_child(child_enable_timer)
		child_enable_timer.start()
	
	$Sprite.modulate = color


func _physics_process(delta: float) -> void:
	offset += speed * delta
	
	if unit_offset >= 1:
		reached_end()


func reached_end():
	emit_signal("end_reached", damage)
	clear_balloon()


func pop() -> void:
	emit_signal("popped", value)
	if child_type != "":
		create_child_balloon()
	clear_balloon()


func create_child_balloon() -> void:
	var child: Balloon = load("res://scenes/balloons/Balloon.tscn").instance()
	
	child.type = child_type
	child.color = GameData.balloon_data[child_type]["color"]
	child.speed = GameData.balloon_data[child_type]["speed"]
	child.value = GameData.balloon_data[child_type]["value"]
	child.damage = GameData.balloon_data[child_type]["damage"]
	
	child.is_child = true
	
	child.offset = offset
	child.get_node("Area2D/CollisionShape2D").disabled = true
	emit_signal("child_spawned", weakref(child)) # emit a signal with reference to the child
	get_parent().call_deferred("add_child", child)


func clear_balloon():
	call_deferred("queue_free")


func _on_ChildSpawnEnablePeriodTimer_timeout() -> void:
	if is_child:
		get_node("Area2D/CollisionShape2D").disabled = false















