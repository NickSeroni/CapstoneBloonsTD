extends Control

onready var tween = $Tween

func _ready() -> void:
	for i in $MarginContainer/VBox.get_children():
		if i is Button:
			i.connect("mouse_entered", self, "_on_Button_mouse_entered", [i])
			i.connect("mouse_exited", self, "_on_Button_mouse_exited", [i])
			
			i.rect_pivot_offset = Vector2(i.rect_size.x/2, i.rect_size.y/2)


func _on_Button_mouse_entered(b: Button) -> void:
	tween.interpolate_property(b, "rect_scale", b.rect_scale, Vector2(1.2, 1.2), 0.4, Tween.TRANS_SINE)
	tween.start()


func _on_Button_mouse_exited(b: Button) -> void:
	tween.interpolate_property(b, "rect_scale", b.rect_scale, Vector2(1, 1), 0.4, Tween.TRANS_SINE)
	tween.start()
