extends CharacterBody3D

@onready var AnimTree = $AnimationTree
@onready var Hand = $Positions/Hand
@onready var FrontColshape = $FrontCS
@onready var FrontArea = $Positions/Front

var playerId
var controllerId
var joystick

var dir = Vector3.ZERO
var doNoInput = false

var speed = 350
var accel = 1

var grav = 70
var jumpforce = 800

var rotationAccel = 0.5
var animateAccel = 0.5

var objectSeen
var objectHeld

var recycler = null
var bid = null
var platform = null

@onready var normalHandpos = $Positions/NormalHandPos.position
@onready var stepHandpos = $Positions/StepHandPos.position

@export var Meshes : Array[MeshInstance3D]

func _ready():
	FrontColshape.disabled = true
	Hand.position = normalHandpos
	
	for i in Manager.playerIndex.size():
		if Manager.playerIndex[i].is_empty():
			break
		
		if Manager.playerIndex[i][0] == playerId:
			controllerId = i
			break
	
	name = "P" + str(controllerId+1)
	if controllerId > 0:
		joystick = Input.get_connected_joypads()[controllerId-1]
	
	ChangeColor()
	ChangeShape()

func ChangeColor():
	var material = StandardMaterial3D.new()
	material.albedo_color = Manager.playerIndex[controllerId][1]
	
	# cycle every shape
	for i in 3:
		if Manager.playerIndex[controllerId][3] == i:
			Meshes[i].material_override = material
			break

func ChangeShape():
	var shape_index = Manager.playerIndex[controllerId][3]
	
	for i in 3:
		if shape_index == i:
			Meshes[i].visible = true
		else:
			Meshes[i].visible = false
	
	ChangeColor()



func _input(event):
	if event.is_action_pressed("InputTest"):
		pass
	
	if controllerId == 0:
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
	var areaEntity = area.get_owner()
	
	if areaEntity.is_in_group("Recycler"):
		recycler = areaEntity
	elif areaEntity.is_in_group("BID"):
		bid = areaEntity
	elif areaEntity.is_in_group("Platform"):
		platform = areaEntity
	else:
		if objectSeen == null:
			objectSeen = areaEntity

func _on_front_area_exited(area):
	var areaEntity = area.get_owner()
	
	if areaEntity.is_in_group("Recycler"):
		recycler = null
	elif areaEntity.is_in_group("BID"):
		bid = null
	elif areaEntity.is_in_group("Platform"):
		platform = null
	else:
		objectSeen = null



func RestartArea():
	FrontArea.monitoring = false
	FrontArea.monitoring = true

func Interact():
	if platform != null:
		platform.NextPointIndex()
		return
		
	elif objectHeld != null and (recycler != null or bid != null):
		
		if recycler != null:
			if objectHeld != null:
				recycler.GarbageCheck(objectHeld)
			
		elif bid != null:
			if objectHeld != null:
				if bid.busy == true:
					return
				bid.BreakDown(objectHeld)
		
		ObjectRemoved(true)
	
	
	if objectSeen != null:
		
		if objectSeen.is_in_group("Object") == true:
			if objectHeld == null:
				GrabObject()
				
			else:
				ObjectRemoved()
		
	else:
		if objectHeld != null:
			ObjectRemoved()
	
	RestartArea()



func GrabObject():
	FrontColshape.disabled = false
	objectSeen.Rb.PlayerGrabbedMe(self)
	
	if objectHeld.is_in_group("Property"):
		Hand.position = stepHandpos
	else:
		Hand.position = normalHandpos
	
	$Sounds/PickUp.play()

func ObjectRemoved(ate = false):
	FrontColshape.disabled = true
	if ate == true:
		objectHeld.Rb.Ate()
	else:
		objectHeld.Rb.PlayerRemovedMe(self)
	
	objectHeld = null

func ThrowObject():
	FrontColshape.disabled = true
	if objectHeld != null:
		objectHeld.Rb.PlayerRemovedMe(self, true)
		objectHeld = null
		$Sounds/Throw.play()



func _physics_process(delta):
	
	# ANIMATION
	if (velocity.x != 0 or velocity.z != 0) and is_on_floor():
		var lookAngle = atan2(-velocity.x, -velocity.z)
		self.rotation.y = lerp_angle(self.rotation.y, lookAngle, rotationAccel)
	
	var postureState = AnimTree.get("parameters/Posture/blend_position")
	
	if velocity.x == 0 and velocity.z == 0:
		AnimTree.set("parameters/Posture/blend_position", lerp(postureState, -1.0, animateAccel))
		
		if objectHeld != null:
			AnimTree.set("parameters/Arms/blend_position", -0.1)
		else:
			AnimTree.set("parameters/Arms/blend_position", -0.2)
		
	else:
		AnimTree.set("parameters/Posture/blend_position", lerp(postureState, 1.0, animateAccel))
		
		if objectHeld != null:
			AnimTree.set("parameters/Arms/blend_position", 0.1)
		else:
			AnimTree.set("parameters/Arms/blend_position", 0.2)
	
	
	
	# MOVEMENT
	var axisXY = Vector2(0,0)
	
	if controllerId > 0 and Input.get_connected_joypads().size() > 0:
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
		if controllerId > 0 and Input.get_connected_joypads().size() > 0:
			if Input.is_joy_button_pressed(joystick, JOY_BUTTON_A):
				velocity.y = jumpforce * delta
				$Sounds/Jump.play()
		else:
			if Input.is_action_just_pressed("Jump"):
				velocity.y = jumpforce * delta
				$Sounds/Jump.play()
	
	if doNoInput == false:
		move_and_slide()
