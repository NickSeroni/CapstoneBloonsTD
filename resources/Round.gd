class_name Round
extends Object

var round_num : int
var wave_array: Array
var waves_left: int

func _init(round_num: int) -> void:
	self.round_num = round_num
	init_waves()
	waves_left = wave_array.size()


func init_waves() -> void:
	if GameData.wave_data.has(round_num):
		wave_array = GameData.wave_data[round_num]
