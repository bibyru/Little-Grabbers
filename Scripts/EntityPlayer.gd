extends CharacterBody3D

@onready var animtree = $AnimationTree
@onready var hand = $Char_GrabberCube/Hand

var playerid
var controllerid
var joystick

var dir = Vector3.ZERO

var speed = 350
var accel = 1

var grav = 1
var jumpforce = 800

var rotaccel = 0.3
var animaccel = 0.5

var objectseen
var objectheld
var objectscale
var recycler = null

var normalhandpos = Vector3(0, 0.645495, -0.653775)
var stephandpos = Vector3(0, 0.65, -0.9)

func _ready():
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
		print("Test: ", objectseen, objectheld)
	
	if controllerid == 0:
		if event.is_action_pressed("Interact"):
			Interact()
		
		if event.is_action_pressed("Throw"):
			ThrowObject()



func _on_front_area_entered(area):
	if area.get_owner().is_in_group("Recycler"):
		recycler = area.get_owner()
	else:
		objectseen = area.get_owner()

func _on_front_area_exited(area):
	if area.get_owner().is_in_group("Recycler"):
		recycler = null
	else:
		objectseen = null


func Interact():
	if recycler != null:
		if objectheld != null:
			recycler.GarbageCheck(objectheld, self)
	
	if objectseen != null:
		
		if objectseen.is_in_group("Garbage") == true or objectseen.is_in_group("Step"):
			if objectheld == null:
				
				var otherplayer = null
				if objectseen.get_parent().get_owner().is_in_group("Player"):
					otherplayer = objectseen.get_parent().get_owner()
				
				if otherplayer == null:
					GrabObject()
				else:
					GrabObject(true)
					otherplayer.ObjectRemoved(true)
				
			else:
				ObjectRemoved()
		
	else:
		if objectheld != null:
			ObjectRemoved()


func GrabObject(from_other_player = false):
	objectheld = load(objectseen.object.path).instantiate()
	objectscale = objectseen.object.iniscale
	
	if from_other_player == false:
		objectseen.get_parent().remove_child(objectseen)
	
	hand.add_child(objectheld)
	if objectheld.is_in_group("Step"):
		hand.position = stephandpos
	else:
		hand.position = normalhandpos
	
	objectheld.object.SetScale(objectscale)
	objectheld.object.set("freeze", true)

func ObjectRemoved(recycled = false):
	objectheld.object.mylocation = hand.global_position
	objectheld.object.myrotation = objectheld.object.global_rotation
	
	objectheld.object.set("freeze", false)
	hand.remove_child(objectheld)
	
	if recycled == false:
		objectheld.object.ReturnToWorld()
	
	objectheld.object.SetScale(objectscale)
	objectheld = null

func ThrowObject():
	if objectheld != null:
		objectheld.object.mylocation = hand.global_position
		objectheld.object.myrotation = objectheld.object.global_rotation
		
		objectheld.object.set("freeze", false)
		hand.remove_child(objectheld)
		objectheld.object.Thrown()
		
		objectheld.object.SetScale(objectscale)
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
	
	
	
	# MOVEMENT
	var axisX
	var axisZ
	
	if controllerid > 0 and Input.get_connected_joypads().size() > 0:
		axisX = Input.get_joy_axis(joystick, JOY_AXIS_LEFT_X)
		axisZ = Input.get_joy_axis(joystick, JOY_AXIS_LEFT_Y)
	else:
		axisX = Input.get_axis("Left", "Right")
		axisZ = Input.get_axis("Forward", "Backward")
	
	velocity.x = move_toward(velocity.x, axisX * speed * delta, accel)
	velocity.z = move_toward(velocity.z, axisZ * speed * delta, accel)
	
	if !is_on_floor():
		velocity.y -= grav
	else:
		if controllerid > 0 and Input.get_connected_joypads().size() > 0:
			if Input.is_joy_button_pressed(joystick, JOY_BUTTON_A):
				velocity.y = jumpforce * delta
		else:
			if Input.is_action_just_pressed("Jump"):
				velocity.y = jumpforce * delta
	
	move_and_slide()
	
	
	
	# ANIMATION
	if velocity.x != 0 or velocity.z != 0:
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
