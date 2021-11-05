class_name Round
extends Object

var wave_array: Array
var balloons_in_round: int

func _init(round_num: int) -> void:
	if GameData.wave_data.has(round_num):
		self.wave_array = GameData.wave_data[round_num]
