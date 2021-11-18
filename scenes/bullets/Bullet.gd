class_name Bullet
extends Area2D

var parent
var lifetime: float = 0.3
var target = null setget set_target
var speed: int
var velocity := Vector2.ZERO
var direction := Vector2.ZERO

# number of balloons this bullet can pop before freeing
var pen := 0
# number of balloons popped with bullet instance
var pop_count := 0

func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")
	$LifetimeTimer.connect("timeout", self, "_on_LifetimeTimer_timeout")
	
	if target.get_ref():
		direction = (target.get_ref().get_global_transform().origin - global_position).normalized()
	
	$LifetimeTimer.start(lifetime)


func _physics_process(delta) -> void:
	velocity = direction * speed
	global_position += velocity * delta


func set_target(new_target) -> void:
	target = weakref(new_target)


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Balloon:
		if !area.get_parent().is_popped:
			area.get_parent().pop()
			pop_count += 1
			parent.pop_count += 1
			parent.emit_signal("stats_changed", parent)
			if pop_count >= pen:
				call_deferred("queue_free")


func _on_LifetimeTimer_timeout() -> void:
	queue_free()
