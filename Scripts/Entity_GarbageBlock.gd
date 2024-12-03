extends Node3D

@export var type = ["wasd"]
@export var reminder = Manager.garbageTypes

@onready var Rb = $RigidBody3D
@onready var RbMesh = $RigidBody3D/Mesh

func _ready():
	add_to_group("GarbageBlock")
	add_to_group("Object")
	
	for i in Manager.garbageTypes.size():
		if Manager.garbageTypes[i] == type:
			var material = StandardMaterial3D.new()
			material.albedo_color = Manager.garbageColors[i]
			RbMesh.material_override = material
