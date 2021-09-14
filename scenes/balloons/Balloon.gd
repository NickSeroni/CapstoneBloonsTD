extends PathFollow2D

signal end_reached

var path: Node
var path_points: Array
var path_index := 0
var velocity := Vector2.ZERO

var type : String
var health
var color 
var speed


func _ready() -> void:
	add_to_group(Groups.BALLOONS)
	
	health = GameData.balloon_data[type]["health"]
	color = GameData.balloon_data[type]["color"]
	speed = GameData.balloon_data[type]["speed"]
	
	$Sprite.modulate = color


func _physics_process(delta: float) -> void:
	offset += speed * delta
	
	if unit_offset >= 1:
		reached_end()


func reached_end():
	emit_signal("end_reached")
	queue_free()


func pop() -> void:
	queue_free()


func apply_damage() -> void:
	health -= 1
	if health <= 0:
		pop()
