extends Node3D

@onready var platform = $RigidBody3D
@export var points : Array[Node3D]

var index = 1
var threshold = 0.1
var speed = 3

@onready var ControlMesh = $RigidBody3D/Control
@onready var controlLocation_side = Vector3(-0.827, 0.644, 0)
@onready var controlLocation_back = Vector3(-0.002, 0.644, -0.538)

@export var controlLocation = 0
@export var locationReminder = ["Side", "Back"]

@export var broken = false



func _ready():
	for point in points:
		point.visible = false
	
	if broken == true:
		$RigidBody3D/Control/Broken.visible = true
		$RigidBody3D/Control/Normal.visible = false
	else:
		$RigidBody3D/Control/Broken.visible = false
		$RigidBody3D/Control/Normal.visible = true
	
	if controlLocation == 0:
		ControlMesh.position = controlLocation_side
		ControlMesh.rotation_degrees = Vector3(0,0,0)
	else:
		ControlMesh.position = controlLocation_back
		ControlMesh.rotation_degrees = Vector3(0,-90,0)



func _physics_process(delta):
	var distance = points[index].global_position - platform.global_position
	var direction = distance.normalized()
	
	if abs(distance.x) > threshold or abs(distance.y) > threshold or abs(distance.z) > threshold:
		if platform.linear_velocity == Vector3.ZERO:
			platform.linear_velocity = speed * direction
	else:
		platform.set("linear_velocity", Vector3.ZERO)
		
		if index + 1 >= 2:
			index = 0
		else:
			index += 1
