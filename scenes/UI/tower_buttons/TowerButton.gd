extends TextureButton

onready var icon := $Icon

export var icon_image: Resource
export var price: int

func _ready():
	icon.texture = icon_image
	$PriceTag/Label.text = "$" + String(price)


func _on_TowerButton_mouse_entered():
	$AnimationPlayer.play("price_tag_slide")


func _on_TowerButton_mouse_exited():
	$AnimationPlayer.play_backwards("price_tag_slide")
