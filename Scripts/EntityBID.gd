extends StaticBody3D

var garbageblock = preload("res://Prefabs/Entities/GarbageBlock.tscn")

@onready var propwarning = $UIPropWarning

# spittype
# 0 = ate a garbage / 1 = ate a block
var spittype = 0
var busy = false

@onready var spitposition = $SpitPosition
@onready var processingtimer = $ProcessingTimer

func _ready():
	add_to_group("BID")

func BreakDown(entity):	
	if entity.is_in_group("Property"):
		propwarning.WarnProp()
		Manager.gameui.UpdateScore(9)
		
	elif entity.is_in_group("Garbage"):
		if processingtimer.is_stopped():
			busy = true
			spittype = 0
			processingtimer.start()
			
			processingtimer.timeout.connect(SpitThing.bind(entity))
		
	elif entity.is_in_group("GarbageBlock"):
		if processingtimer.is_stopped():
			busy = true
			spittype = 1
			processingtimer.start()
			
			processingtimer.timeout.connect(SpitThing.bind(entity))

func SpitThing(entity):
	processingtimer.disconnect("timeout", SpitThing)
	
	if spittype == 0:
		for i in entity.type:
			var block = garbageblock.instantiate()
			block.type = i
			block.name = "Block" + block.type
			spitposition.add_child(block)
			block.object.Thrown( Vector3(RandomNumber(), 0, RandomNumber()) )
		
	elif spittype == 1:
		spitposition.add_child(entity)
		entity.object.ObjectActivate()
		entity.global_position = spitposition.global_position
		entity.object.Thrown( Vector3(RandomNumber(), 0, RandomNumber()) )
	
	busy = false

func RandomNumber():
	return randf_range(-1.0, 1.0)
