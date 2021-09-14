extends TextureButton


func _on_TowerButton_mouse_entered():
	$AnimationPlayer.play("price_tag_slide")


func _on_TowerButton_mouse_exited():
	$AnimationPlayer.play_backwards("price_tag_slide")
