extends Node3D

var total_garbage

func _ready():
	total_garbage = get_tree().get_nodes_in_group("Garbage").size()

func SubtractGarbage():
	total_garbage -= 1
	
	if total_garbage < 1:
		FinishLevel()

func FinishLevel():
	pass
