extends TextureButton

onready var icon := $Icon

export var icon_image: Texture
export var price: int
onready var type: String = name + "1"

func _ready():
	icon.texture = icon_image
	$PriceTag/Label.text = "$" + String(GameData.tower_data[type]["price"])


func _on_TowerButton_mouse_entered():
	$AnimationPlayer.play("price_tag_slide")


func _on_TowerButton_mouse_exited():
	$AnimationPlayer.play_backwards("price_tag_slide")
