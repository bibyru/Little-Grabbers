extends RigidBody3D

@export var path = "wasd"

var myLocation = Vector3.ZERO
var myRotation = Vector3.ZERO

@onready var Parent = $"../"

func _ready():
	gravity_scale = 3
	
	if Manager.objectCollision == true:
		set_collision_mask_value(2, true)
	else:
		set_collision_mask_value(2, false)

func ResetPosition(obj):
	obj.position = Vector3.ZERO
	obj.rotation = Vector3.ZERO

func Ate():
	Parent.get_parent().remove_child(Parent)



func ObjectActivate():
	freeze = false
	$CollisionShape3D.disabled = false

func ObjectDisable():
	freeze = true
	$CollisionShape3D.disabled = true


func PlayerGrabbedMe(player):
	# if object being held by player, clear its objectHeld
	var grandparent = Parent.get_parent()
	if grandparent.name == "Hand":
		grandparent.get_parent().get_parent().objectHeld = null
	
	grandparent.remove_child(Parent)
	grandparent = null
	
	player.Hand.add_child(Parent)
	player.objectHeld = Parent
	
	ResetPosition(Parent)
	ResetPosition(self)
	
	ObjectDisable()


func PlayerRemovedMe(player, thrown = false):
	myLocation = global_position
	myRotation = global_rotation
	player.Hand.remove_child(Parent)
	
	Manager.ItemSpawner.add_child(Parent)
	global_position = myLocation
	global_rotation = myRotation
	
	ObjectActivate()
	
	if thrown == true:
		Thrown()

func Thrown(random_dir = Vector3(), throwStrength = 0):
	if throwStrength == 0:
		throwStrength = -8
	
	var throwDirection = global_transform.basis.z.normalized()
	if random_dir != Vector3():
		throwDirection = random_dir
	
	apply_impulse(throwDirection * throwStrength + Vector3(0,12,0))
