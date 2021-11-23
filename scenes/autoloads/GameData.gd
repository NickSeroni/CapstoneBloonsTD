extends Node


var tower_data = {
	"Gun1": {
		"rof": 1.5,
		"radius": 100,
		"splash": false,
		"bullet": "res://scenes/bullets/Bullet.tscn",
		"bullet_speed": 900,
		"price": 215,
		"pen": 2,
		"tier": 1,
		"type": "Gun"
	},
	"Missile1": {
		"rof": 2,
		"radius": 150,
		"splash": true,
		"bullet": "res://scenes/bullets/Missile.tscn",
		"bullet_speed": 700,
		"price": 300,
		"pen": 2,
		"tier": 1,
		"type": "Missile"
	}
}

var balloon_data = {
	"Red": {
		"color": Color.red,
		"speed": 110,
		"value": 1,
		"damage": 1
	},
	"Blue": {
		"child": "Red",
		"color": Color.blue,
		"speed": 130,
		"value": 2,
		"damage": 2
	},
	"Green": {
		"child": "Blue",
		"color": Color.green,
		"speed": 170,
		"value": 3,
		"damage": 3
	},
	"Yellow": {
		"child": "Green",
		"color": Color.yellow,
		"speed": 210,
		"value": 4,
		"damage": 4
	}
}

# Iterating through the array yields the key to the level dictionary
var levelArray = [
	"Plains",
	"Winterland",
	"Moon",
]

# Completed changes upon winning a level, then is saved to a file
# When game loads, the completed value is read from the save file
var levelDict = {
	"Plains": {
		"img": "res://assets/TowerDefenseMap01.png",
		"scene": "res://scenes/levels/level01/Level01.tscn",
		"completed": false,
	},
	"Winterland": {
		"img": "res://assets/winter-map.png",
		"scene": "res://scenes/levels/winterland/Winterland.tscn",
		"completed": false,
	},
	"Moon": {
		"img": "res://assets/MoonMap.png",
		"scene": "res://scenes/levels/MoonMap.tscn",
		"completed": false,
	},
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
			"count": 35
		},
	],
	3: [
		{
			"type": "Red",
			"count": 25
		},
		{
			"type": "Blue",
			"count": 5
		},
	],
	4: [
		{
			"type": "Red",
			"count": 35
		},
		{
			"type": "Blue",
			"count": 18
		},
	],
	5: [
		{
			"type": "Red",
			"count": 5
		},
		{
			"type": "Blue",
			"count": 27
		},
	],
	6: [
		{
			"type": "Red",
			"count": 15
		},
		{
			"type": "Blue",
			"count": 15
		},
		{
			"type": "Green",
			"count": 4
		}
	],
	7: [
		{
			"type": "Red",
			"count": 20
		},
		{
			"type": "Blue",
			"count": 20
		},
		{
			"type": "Green",
			"count": 5
		}
	],
	8: [
		{
			"type": "Red",
			"count": 10
		},
		{
			"type": "Blue",
			"count": 20
		},
		{
			"type": "Green",
			"count": 14
		}
	],
	9: [
		{
			"type": "Green",
			"count": 30
		}
	],
	10: [
		{
			"type": "Blue",
			"count": 102
		}
	],
	11: [
		{
			"type": "Red",
			"count": 10
		},
		{
			"type": "Blue",
			"count": 10
		},
		{
			"type": "Green",
			"count": 12
		},
		{
			"type": "Yellow",
			"count": 3
		},
	],
	12: [
		{
			"type": "Blue",
			"count": 15
		},
		{
			"type": "Green",
			"count": 10
		},
		{
			"type": "Yellow",
			"count": 5
		},
	],
	13: [
		{
			"type": "Blue",
			"count": 50
		},
		{
			"type": "Green",
			"count": 23
		},
	],
	14: [
		{
			"type": "Red",
			"count": 49
		},
		{
			"type": "Blue",
			"count": 15
		},
		{
			"type": "Green",
			"count": 10
		},
		{
			"type": "Yellow",
			"count": 9
		},
	],
	15: [
		{
			"type": "Red",
			"count": 20
		},
		{
			"type": "Blue",
			"count": 15
		},
		{
			"type": "Green",
			"count": 12
		},
		{
			"type": "Yellow",
			"count": 10
		},
		{
			"type": "Red",
			"count": 5
		},
	],
	16: [
		{
			"type": "Green",
			"count": 40
		},
		{
			"type": "Yellow",
			"count": 8
		},
	],
}
