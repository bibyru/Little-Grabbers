extends Node3D

var loadrecycler = preload("res://Prefabs/Entities/Recycler.tscn")

@export var type = "wasd"
@export var reminder = Manager.garbage_types

func _ready():
	remove_child(get_child(0))
	var recycler = loadrecycler.instantiate()
	recycler.type = type
	add_child(recycler)
