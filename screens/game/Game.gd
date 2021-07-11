extends Node2D


onready var _pyramids = $Platforms/Platform9/Pyramids
onready var _stone = $Platforms/Platform2/Stonehenge
onready var _taj = $"Platforms/Platform5/Taj Mahal"
onready var _end: DialogUI = $DialogUI


func _on_Stonehenge_influence_changed():
	_check_win()


func _on_Taj_Mahal_influence_changed():
	_check_win()


func _on_Pyramids_influence_changed():
	_check_win()


func _check_win():
	if _pyramids.influence == 1 and _stone.influence == 1 and _taj.influence == 1 and is_instance_valid(_end):
		_end.activate()
