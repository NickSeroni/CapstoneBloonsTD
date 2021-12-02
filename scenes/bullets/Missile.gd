extends Bullet

# Array of balloons within explosion range at time of detonation
var balloons_in_radius: Array

# Upgradable stats
export var explosion_radius := 60

onready var explosion_area : Area2D = $ExplosionArea2D

func _ready() -> void:
	$FreeTimer.connect("timeout", self, "_on_FreeTimer_timeout")
	explosion_area.connect("area_entered", self, "_on_ExplosionArea_area_entered")
	explosion_area.connect("area_exited", self, "_on_ExplosionArea_area_exited")
	
	lifetime = 0.8
	explosion_area.get_node("ExplosionShape2D").shape.radius = explosion_radius
	
	if target.get_ref():
		direction = (target.get_ref().get_global_transform().origin - global_position).normalized()
	
	$LifetimeTimer.start(lifetime)

# Specific to missiles, EXPLOSION
func detonate():
	$Sprite.set_deferred("visible", false) # make invisible
	$CollisionShape2D.set_deferred("disabled", true) # ensure only 1 explosion
	
	direction = Vector2.ZERO
	$Particles2D.restart()
	$Particles2D/Particles2D.restart()
	$AudioStreamPlayer.play()
	
	for b in balloons_in_radius:
		if !b.is_popped:
			b.pop()
			pop_count += 1
			parent.pop_count += 1
			parent.emit_signal("stats_changed", parent)
	
	$FreeTimer.start(1.1) # ensure the particle effects run their course


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Balloon:
		detonate()


func _on_FreeTimer_timeout() -> void:
	call_deferred("queue_free")


func _on_ExplosionArea_area_entered(area: Area2D) -> void:
	if area.get_parent() is Balloon:
		balloons_in_radius.push_back(area.get_parent())


func _on_ExplosionArea_area_exited(area: Area2D) -> void:
	if area.get_parent() is Balloon:
		balloons_in_radius.erase(area.get_parent())


