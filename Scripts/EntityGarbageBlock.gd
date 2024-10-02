extends Node3D

@export var type = "wasd"
@export var reminder = Manager.garbage_types

@onready var object = $RigidBody3D
@onready var mesh = $RigidBody3D/Mesh

func _ready():
	add_to_group("GarbageBlock")
	add_to_group("Object")
	
	for i in Manager.garbage_types.size():
		if Manager.garbage_types[i] == type:
			var material = StandardMaterial3D.new()
			material.albedo_color = Manager.garbage_colors[i]
			mesh.material_override = material
