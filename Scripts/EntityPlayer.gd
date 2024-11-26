extends CharacterBody3D

@onready var animtree = $AnimationTree
@onready var hand = $Positions/Hand
@onready var frontcolshape = $FrontCS
@onready var frontarea = $Positions/Front

var playerid
var controllerid
var joystick

var dir = Vector3.ZERO
var no_input = false

var speed = 350
var accel = 1

var grav = 70
var jumpforce = 800

var rotaccel = 0.5
var animaccel = 0.5

var objectseen
var objectheld

var recycler = null
var bid = null
var platform = null

@onready var normalhandpos = $Positions/NormalHandPos.position
@onready var stephandpos = $Positions/StepHandPos.position

@export var meshes : Array[MeshInstance3D]

func _ready():
	frontcolshape.disabled = true
	hand.position = normalhandpos
	
	for i in Manager.playerindex.size():
		if Manager.playerindex[i].is_empty():
			break
		
		if Manager.playerindex[i][0] == playerid:
			controllerid = i
			break
	
	name = "P" + str(controllerid+1)
	if controllerid > 0:
		joystick = Input.get_connected_joypads()[controllerid-1]
	
	ChangeColor()
	ChangeShape()

func ChangeColor():
	var material = StandardMaterial3D.new()
	material.albedo_color = Manager.playerindex[controllerid][1]
	
	# cycle every shape
	for i in 3:
		if Manager.playerindex[controllerid][3] == i:
			meshes[i].material_override = material
			break

func ChangeShape():
	var shape_index = Manager.playerindex[controllerid][3]
	
	for i in 3:
		if shape_index == i:
			meshes[i].visible = true
		else:
			meshes[i].visible = false
	
	ChangeColor()



func _input(event):
	if event.is_action_pressed("InputTest"):
		pass
	
	if controllerid == 0:
		if event.is_action_pressed("Interact"):
			Interact()
		
		if event.is_action_pressed("Throw"):
			ThrowObject()
		
	else:
		if event.device == joystick:
			if event.is_action_pressed("JoyInteract"):
				Interact()
			
			if event.is_action_pressed("JoyThrow"):
				ThrowObject()



func _on_front_area_entered(area):
	var area_entity = area.get_owner()
	
	if area_entity.is_in_group("Recycler"):
		recycler = area_entity
	elif area_entity.is_in_group("BID"):
		bid = area_entity
	elif area_entity.is_in_group("Platform"):
		platform = area_entity
	else:
		if objectseen == null:
			objectseen = area_entity

func _on_front_area_exited(area):
	var area_entity = area.get_owner()
	
	if area_entity.is_in_group("Recycler"):
		recycler = null
	elif area_entity.is_in_group("BID"):
		bid = null
	elif area_entity.is_in_group("Platform"):
		platform = null
	else:
		objectseen = null



func RestartArea():
	frontarea.monitoring = false
	frontarea.monitoring = true

func Interact():
	if platform != null:
		platform.NextPointIndex()
		return
		
	elif objectheld != null and (recycler != null or bid != null):
		
		if recycler != null:
			if objectheld != null:
				recycler.GarbageCheck(objectheld)
			
		elif bid != null:
			if objectheld != null:
				if bid.busy == true:
					return
				bid.BreakDown(objectheld)
		
		ObjectRemoved(true)
	
	
	if objectseen != null:
		
		if objectseen.is_in_group("Object") == true:
			if objectheld == null:
				GrabObject()
				
			else:
				ObjectRemoved()
		
	else:
		if objectheld != null:
			ObjectRemoved()
	
	RestartArea()



func GrabObject():
	frontcolshape.disabled = false
	objectseen.object.PlayerGrabbedMe(self)
	
	if objectheld.is_in_group("Property"):
		hand.position = stephandpos
	else:
		hand.position = normalhandpos

func ObjectRemoved(ate = false):
	frontcolshape.disabled = true
	if ate == true:
		objectheld.object.Ate()
	else:
		objectheld.object.PlayerRemovedMe(self)
	
	objectheld = null

func ThrowObject():
	frontcolshape.disabled = true
	if objectheld != null:
		objectheld.object.PlayerRemovedMe(self, true)
		
		objectheld = null



func _physics_process(delta):
	
	# ANIMATION
	if (velocity.x != 0 or velocity.z != 0) and is_on_floor():
		var lookangle = atan2(-velocity.x, -velocity.z)
		self.rotation.y = lerp_angle(self.rotation.y, lookangle, rotaccel)
	
	var posture_state = animtree.get("parameters/Posture/blend_position")
	
	if velocity.x == 0 and velocity.z == 0:
		animtree.set("parameters/Posture/blend_position", lerp(posture_state, -1.0, animaccel))
		
		if objectheld != null:
			animtree.set("parameters/Arms/blend_position", -0.1)
		else:
			animtree.set("parameters/Arms/blend_position", -0.2)
		
	else:
		animtree.set("parameters/Posture/blend_position", lerp(posture_state, 1.0, animaccel))
		
		if objectheld != null:
			animtree.set("parameters/Arms/blend_position", 0.1)
		else:
			animtree.set("parameters/Arms/blend_position", 0.2)
	
	
	
	# MOVEMENT
	var axisXY = Vector2(0,0)
	
	if controllerid > 0 and Input.get_connected_joypads().size() > 0:
		axisXY.x = Input.get_joy_axis(joystick, JOY_AXIS_LEFT_X)
		axisXY.y = Input.get_joy_axis(joystick, JOY_AXIS_LEFT_Y)
	else:
		axisXY.x = Input.get_axis("Left", "Right")
		axisXY.y = Input.get_axis("Forward", "Backward")
	
	if !is_on_wall_only():
		axisXY = axisXY.normalized()
		velocity.x = move_toward(velocity.x, axisXY.x * speed * delta, accel)
		velocity.z = move_toward(velocity.z, axisXY.y * speed * delta, accel)
	
	if !is_on_floor():
		velocity.y -= grav * delta
	else:
		if controllerid > 0 and Input.get_connected_joypads().size() > 0:
			if Input.is_joy_button_pressed(joystick, JOY_BUTTON_A):
				velocity.y = jumpforce * delta
		else:
			if Input.is_action_just_pressed("Jump"):
				velocity.y = jumpforce * delta
	
	if no_input == false:
		move_and_slide()
