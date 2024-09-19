extends Node3D

@export var type = "wasd"
@export var reminder = Manager.garbage_types

@onready var object = $RigidBody3D

func _ready():
	add_to_group("Garbage")
