extends Node


var tower_data = {
	"GunT1": {
		"damage": 20,
		"rof": 0.1,
		"radius": 150,
		"splash": false,
		"bullet": "res://scenes/bullets/Bullet.tscn",
		"bullet_speed": 2000,
		"price": 150
	},
	"MissleT1": {
		"damage": 100,
		"rof": 1,
		"radius": 150,
		"splash": true,
		"bullet": "",
		"bullet_speed": 300,
		"price": 250
	}
}

var balloon_data = {
	"Red": {
		"health": 1,
		"color": Color.red,
		"speed": 100
	},
	"Blue": {
		"health": 2,
		"color": Color.blue,
		"speed": 500
	}
}
