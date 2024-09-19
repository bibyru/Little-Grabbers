extends Node3D

@onready var object = $RigidBody3D

func _ready():
	add_to_group("Step")
