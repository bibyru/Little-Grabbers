extends CharacterBody3D

@onready var animtree = $AnimationTree
@onready var hand = $Char_GrabberCube/Hand
@onready var frontcolshape = $FrontCS

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

@onready var normalhandpos = $Char_GrabberCube/NormalHandPos.position
@onready var stephandpos = $Char_GrabberCube/StepHandPos.position



func _ready():
	frontcolshape.disabled = true
	hand.position = normalhandpos
	
	for i in Manager.playerindex.size():
		if Manager.playerindex[i][0] == playerid:
			controllerid = i
	
	name = "P" + str(controllerid+1)
	if controllerid > 0:
		joystick = Input.get_connected_joypads()[controllerid-1]
	
	ChangeColor()

func ChangeColor():
	var material = StandardMaterial3D.new()
	material.albedo_color = Manager.playerindex[controllerid][1]
	$Char_GrabberCube/Armature_GrabberCube/Skeleton3D/Mesh_Arms.material_override = material
	$Char_GrabberCube/Armature_GrabberCube/Skeleton3D/Mesh_Body.material_override = material
	$Char_GrabberCube/Armature_GrabberCube/Skeleton3D/Mesh_Legs.material_override = material



func _input(event):
	if event.is_action_pressed("InputTest"):
		print("<-Test->")
		print(objectheld.type)
		print("<-Test end->\n")
	
	if controllerid == 0:
		if event.is_action_pressed("Interact"):
			Interact()
		
		if event.is_action_pressed("Throw"):
			ThrowObject()



func _on_front_area_entered(area):
	var area_entity = area.get_owner()
	
	if area_entity.is_in_group("Recycler"):
		recycler = area_entity
	elif area_entity.is_in_group("BID"):
		bid = area_entity
	else:
		objectseen = area_entity

func _on_front_area_exited(area):
	var area_entity = area.get_owner()
	
	if area_entity.is_in_group("Recycler"):
		recycler = null
	elif area_entity.is_in_group("BID"):
		bid = null
	else:
		objectseen = null


func Interact():
	if objectheld != null and (recycler != null or bid != null):
		
		if recycler != null:
			if objectheld != null:
				recycler.GarbageCheck(objectheld)
			
		elif bid != null:
			if objectheld != null:
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



var flag_joyX = false
var flag_joyY = false

func _physics_process(delta):
	# CONTROLLER INPUT
	if Input.is_joy_button_pressed(controllerid-1, JOY_BUTTON_X):
		if flag_joyX == false:
			flag_joyX = true
			Interact()
	else:
		flag_joyX = false
	
	if Input.is_joy_button_pressed(controllerid-1, JOY_BUTTON_Y):
		if flag_joyY == false:
			flag_joyY = true
			ThrowObject()
	else:
		flag_joyY = false
	
	
	
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
	var axisX
	var axisZ
	
	if controllerid > 0 and Input.get_connected_joypads().size() > 0:
		axisX = Input.get_joy_axis(joystick, JOY_AXIS_LEFT_X)
		axisZ = Input.get_joy_axis(joystick, JOY_AXIS_LEFT_Y)
	else:
		axisX = Input.get_axis("Left", "Right")
		axisZ = Input.get_axis("Forward", "Backward")
	
	if !is_on_wall_only():
		velocity.x = move_toward(velocity.x, axisX * speed * delta, accel)
		velocity.z = move_toward(velocity.z, axisZ * speed * delta, accel)
	
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
