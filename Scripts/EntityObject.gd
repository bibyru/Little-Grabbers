extends RigidBody3D

@export var path = "wasd"

var mylocation = Vector3.ZERO
var myrotation = Vector3.ZERO

var iniscale
@onready var mesh = $Mesh
@onready var colshape = $CollisionShape3D

func _ready():
	gravity_scale = 3
	iniscale = [mesh.scale, colshape.shape.size]

func SetScale(given_scale):
	iniscale = given_scale
	mesh.scale = iniscale[0]
	colshape.shape.size = iniscale[1]

func ReturnToWorld():
	Manager.itemspawner.add_child(get_parent())
	global_position = mylocation
	global_rotation = myrotation

func Thrown():
	ReturnToWorld()
	apply_impulse(global_transform.basis.z.normalized() * -10 + Vector3(0,10,0))
