extends Node3D

var recyclerLoad = preload("res://Prefabs/Entities/Recycler.tscn")

@export var type = "wasd"
@export var reminder = Manager.garbageTypes

func _ready():
	remove_child(get_child(0))
	var recycler = recyclerLoad.instantiate()
	recycler.type = type
	add_child(recycler)
