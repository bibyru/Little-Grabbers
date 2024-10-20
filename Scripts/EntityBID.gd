extends StaticBody3D

var garbageblock = preload("res://Prefabs/Entities/GarbageBlock.tscn")

@onready var propwarning = $UIPropWarning

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
		
	elif spittype == 1:
		spitposition.add_child(entity)
		entity.object.ObjectActivate()
		entity.global_position = spitposition.global_position
	
	busy = false
