extends Node


var tower_data = {
	"GunT1": {
		"rof": 1,
		"radius": 100,
		"splash": false,
		"bullet": "res://scenes/bullets/Bullet.tscn",
		"bullet_speed": 800,
		"price": 200,
		"pen": 2
	},
	"MissleT1": {
		"rof": 1,
		"radius": 150,
		"splash": true,
		"bullet": "res://assets/TowerDefensePack/MissleT1.png",
		"bullet_speed": 300,
		"price": 300,
		"pen": 2
	}
}

var balloon_data = {
	"Red": {
		"color": Color.red,
		"speed": 100,
		"value": 1,
		"damage": 1
	},
	"Blue": {
		"child": "Red",
		"color": Color.blue,
		"speed": 120,
		"value": 2,
		"damage": 2
	},
	"Green": {
		"child": "Blue",
		"color": Color.green,
		"speed": 140,
		"value": 3,
		"damage": 3
	}
}

var wave_data = {
	1: [ 
		{
			"type": "Red",
			"count": 20
		}
	],
	2: [
		{
			"type": "Red",
			"count": 20
		},
		{
			"type": "Blue",
			"count": 5
		}
	],
	3: [
		{
			"type": "Red",
			"count": 20
		},
		{
			"type": "Blue",
			"count": 10
		},
		{
			"type": "Red",
			"count": 20
		},
	],
	4: [
		{
			"type": "Red",
			"count": 20
		},
		{
			"type": "Blue",
			"count": 10
		},
		{
			"type": "Red",
			"count": 20
		},
		{
			"type": "Blue",
			"count": 10
		},
		{
			"type": "Red",
			"count": 20
		},
	],
	5: [
		{
			"type": "Red",
			"count": 20
		},
		{
			"type": "Blue",
			"count": 10
		},
		{
			"type": "Red",
			"count": 20
		},
		{
			"type": "Blue",
			"count": 10
		},
		{
			"type": "Red",
			"count": 20
		},
		{
			"type": "Green",
			"count": 10
		},
		{
			"type": "Blue",
			"count": 20
		},
	],
}

# Iterating through the array yields the key to the level dictionary
var levelArray = [
	"Plains",
	"Plains",
	"Plains",
	"Plains",
	
]

var levelDict = {
	"Plains": {
		"img": "res://assets/TowerDefenseMap01.png",
		"scene": "res://scenes/levels/level01/Level01.tscn",
	},
}
