extends Control

onready var _anim_player = $AnimationPlayer

func _ready():
	_anim_player.play("buttons")
