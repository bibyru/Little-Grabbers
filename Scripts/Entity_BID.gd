extends StaticBody3D

var garbageBlock = preload("res://Prefabs/Entities/GarbageBlock.tscn")

@onready var PropWarning = $UIPropWarning

# spittype
# 0 = ate a garbage / 1 = ate a block
var spittype = 0
var busy = false

@onready var SpitPosition = $SpitPosition
@onready var ProcessingTimer = $ProcessingTimer

func _ready():
	add_to_group("BID")

func BreakDown(entity):	
	if entity.is_in_group("Property"):
		PropWarning.WarnProp()
		Manager.GameUI.UpdateScore(9)
		
	elif entity.is_in_group("Garbage"):
		if ProcessingTimer.is_stopped():
			busy = true
			spittype = 0
			ProcessingTimer.start()
			
			ProcessingTimer.timeout.connect(SpitThing.bind(entity))
		
	elif entity.is_in_group("GarbageBlock"):
		if ProcessingTimer.is_stopped():
			busy = true
			spittype = 1
			ProcessingTimer.start()
			
			ProcessingTimer.timeout.connect(SpitThing.bind(entity))

func SpitThing(entity):
	ProcessingTimer.disconnect("timeout", SpitThing)
	
	if spittype == 0:
		for i in entity.type:
			var block = garbageBlock.instantiate()
			block.type = i
			block.name = "Block" + block.type
			SpitPosition.add_child(block)
			block.Rb.Thrown( Vector3(RandomNumber(), 0, RandomNumber()) )
		
	elif spittype == 1:
		SpitPosition.add_child(entity)
		entity.Rb.ObjectActivate()
		entity.global_position = SpitPosition.global_position
		entity.Rb.Thrown( Vector3(RandomNumber(), 0, RandomNumber()) )
	
	busy = false

func RandomNumber():
	return randf_range(-1.0, 1.0)
