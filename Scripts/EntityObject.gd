extends RigidBody3D

@export var path = "wasd"

var mylocation = Vector3.ZERO
var myrotation = Vector3.ZERO

@onready var mesh = $Mesh
@onready var colshape = $CollisionShape3D
@onready var parent = $"../"

func _ready():
	gravity_scale = 3

func ReturnToWorld():
	Manager.itemspawner.add_child(parent)
	global_position = mylocation
	global_rotation = myrotation

func Thrown():
	ReturnToWorld()
	apply_impulse(global_transform.basis.z.normalized() * -10 + Vector3(0,10,0))



func ResetPosition():
	parent.position = Vector3.ZERO
	position = Vector3.ZERO
	parent.rotation = Vector3.ZERO
	rotation = Vector3.ZERO

func PlayerGrabMe(player):
	parent.get_parent().remove_child(parent)
	player.hand.add_child(parent)
	player.objectheld = parent
	
	ResetPosition()
	freeze = true
