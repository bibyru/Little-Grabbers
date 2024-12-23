extends StaticBody3D

var garbageBlock = preload("res://Prefabs/Entities/GarbageBlock.tscn")

@onready var PropWarning = $UIPropWarning

# spitType
# 0 = ate a garbage / 1 = ate a block
var spitType = 0
var spitStrength = -5
var busy = false

@onready var SpitPosition = $SpitPosition
@onready var ProcessingTimer = $ProcessingTimer

func _ready():
	add_to_group("BID")

func BreakDown(entity):
	if entity.is_in_group("Property"):
		PropWarning.WarnProp()
		Manager.GameUI.UpdateScore(9)
		$Sound.play()
		
	elif entity.is_in_group("Garbage"):
		if ProcessingTimer.is_stopped():
			busy = true
			spitType = 0
			ProcessingTimer.start()
			
			ProcessingTimer.timeout.connect(SpitThing.bind(entity))
			$Sound.play()
		
	elif entity.is_in_group("GarbageBlock"):
		if ProcessingTimer.is_stopped():
			busy = true
			spitType = 1
			ProcessingTimer.start()
			
			ProcessingTimer.timeout.connect(SpitThing.bind(entity))
			$Sound.play()

func SpitThing(entity):
	ProcessingTimer.disconnect("timeout", SpitThing)
	
	if spitType == 0:
		for i in entity.type:
			var block = garbageBlock.instantiate()
			block.type = i
			block.name = "Block" + block.type
			SpitPosition.add_child(block)
			block.Rb.Thrown( Vector3(RandomNumber(), 0, RandomNumber()), spitStrength )
		
	elif spitType == 1:
		SpitPosition.add_child(entity)
		entity.Rb.ObjectActivate()
		entity.global_position = SpitPosition.global_position
		entity.Rb.Thrown( Vector3(RandomNumber(), 0, RandomNumber()), spitStrength )
	
	busy = false

func RandomNumber():
	var randomNumber = randf_range(0.5, 1)
	
	var randomSign = randi_range(0, 1)
	if randomSign == 1:
		return randomNumber * -1
	
	return randomNumber
