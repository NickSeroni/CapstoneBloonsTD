extends Area2D


var target = null
var speed
var velocity := Vector2.ZERO
var direction := Vector2.ZERO


func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")
	add_to_group(Groups.BULLETS)
	
	if target.get_ref():
		direction = (target.get_ref().get_global_transform().origin - global_position).normalized()


func _physics_process(delta) -> void:
	if target.get_ref():
		velocity = direction * speed
		global_position += velocity * delta
	else:
		queue_free()


func set_target(new_target) -> void:
	target = weakref(new_target)


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group(Groups.BALLOONS):
		if area.get_parent() == target.get_ref():
			area.get_parent().apply_damage()
		queue_free()
