extends StaticBody3D

var garbageblock = preload("res://Prefabs/GarbageBlock.tscn")

@onready var propwarning = $UIPropWarning

var spittype = 0

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
			spittype = 0
			processingtimer.start()
			
			processingtimer.timeout.connect(SpitThing.bind(entity))
		
	elif entity.is_in_group("GarbageBlock"):
		if processingtimer.is_stopped():
			spittype = 1
			processingtimer.start()
			
			entity.object.Ate()
			
			processingtimer.timeout.connect(SpitThing.bind(entity))

func SpitThing(entity):
	processingtimer.disconnect("timeout", SpitThing)
	
	if spittype == 0:
		var block = garbageblock.instantiate()
		block.type = entity.type
		spitposition.add_child(block)
		
	elif spittype == 1:
		spitposition.add_child(entity)
		entity.global_position = spitposition.global_position
