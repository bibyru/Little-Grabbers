extends Node3D

@onready var Platform = $RigidBody3D
@export var Points : Array[Node3D]
@export var speed = 3

var index = 1
var threshold = 0.1

@onready var ControlMesh = $RigidBody3D/Control
@onready var controlLocationSide = Vector3(-0.827, 0.644, 0)
@onready var controlLocationBack = Vector3(-0.002, 0.644, -0.538)

@export var controlLocation = 0
@export var locationReminder = ["Side", "Back"]

@export var broken = false
@export var manual = false

var isFinishedMoving = true



func _ready():
	add_to_group("Platform")
	
	for point in Points:
		point.visible = false
	
	if broken == true:
		$RigidBody3D/Control/Broken.visible = true
		$RigidBody3D/Control/Normal.visible = false
	else:
		$RigidBody3D/Control/Broken.visible = false
		$RigidBody3D/Control/Normal.visible = true
	
	if controlLocation == 0:
		ControlMesh.position = controlLocationSide
		ControlMesh.rotation_degrees = Vector3(0,0,0)
	else:
		ControlMesh.position = controlLocationBack
		ControlMesh.rotation_degrees = Vector3(0,-90,0)


func NextPointIndex():
	if isFinishedMoving == true:
		if index + 1 >= 2:
			index = 0
			return
		index += 1


func _physics_process(delta):
	var distance = Points[index].global_position - Platform.global_position
	var direction = distance.normalized()
	
	if abs(distance.x) > threshold or abs(distance.y) > threshold or abs(distance.z) > threshold:
		if Platform.linear_velocity == Vector3.ZERO:
			Platform.linear_velocity = speed * direction
			isFinishedMoving = false
	else:
		Platform.set("linear_velocity", Vector3.ZERO)
		isFinishedMoving = true
		
		if manual == false:
			NextPointIndex()
