extends Node3D

@onready var platform = $CSGBox3D
@export var points : Array[Node3D]
var index = 0

func _physics_process(delta):
	if platform.position != points[index].position:
		platform.position.x = move_toward(platform.position.x, points[index].position.x, delta)
		platform.position.y = move_toward(platform.position.y, points[index].position.y, delta)
		platform.position.z = move_toward(platform.position.z, points[index].position.z, delta)
	else:
		if index + 1 >= 2:
			index = 0
		else:
			index += 1
