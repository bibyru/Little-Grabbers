extends Node3D

@onready var Rb = $RigidBody3D

func _ready():
	add_to_group("Property")
	add_to_group("Object")
