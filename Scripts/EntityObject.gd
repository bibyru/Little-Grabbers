extends RigidBody3D

@export var path = "wasd"

var mylocation = Vector3.ZERO
var myrotation = Vector3.ZERO

@onready var mesh = $Mesh
@onready var colshape = $CollisionShape3D
@onready var parent = $"../"

func _ready():
	gravity_scale = 3
	set_collision_mask_value(2, true)

func ResetPosition(obj):
	obj.position = Vector3.ZERO
	obj.rotation = Vector3.ZERO

func Ate():
	parent.get_parent().remove_child(parent)



func ObjectActivate():
	freeze = false
	$CollisionShape3D.disabled = false

func ObjectDisable():
	freeze = true
	$CollisionShape3D.disabled = true


func PlayerGrabbedMe(player):
	# if object being held by player, clear its objectheld
	var grandparent = parent.get_parent()
	if grandparent.name == "Hand":
		grandparent.get_parent().get_parent().objectheld = null
	
	grandparent.remove_child(parent)
	grandparent = null
	
	player.hand.add_child(parent)
	player.objectheld = parent
	
	ResetPosition(parent)
	ResetPosition(self)
	
	ObjectDisable()


func PlayerRemovedMe(player, thrown = false):
	mylocation = global_position
	myrotation = global_rotation
	player.hand.remove_child(parent)
	
	Manager.itemspawner.add_child(parent)
	global_position = mylocation
	global_rotation = myrotation
	
	ObjectActivate()
	
	if thrown == true:
		apply_impulse(global_transform.basis.z.normalized() * -8 + Vector3(0,12,0))
