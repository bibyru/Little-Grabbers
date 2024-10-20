extends Node3D

@onready var platform = $RigidBody3D
@export var points : Array[Node3D]
var index = 0
var threshold = 0.1
var speed = 3

func _physics_process(delta):
	var distance = points[index].global_position - platform.global_position
	var direction = distance.normalized()
	
	if abs(distance.x) > threshold or abs(distance.y) > threshold or abs(distance.z) > threshold:
		platform.apply_force(speed * direction)
	else:
		platform.set("linear_velocity", Vector3.ZERO)
		if index + 1 >= 2:
			index = 0
		else:
			index += 1
