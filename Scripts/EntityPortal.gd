extends Node3D

@onready var tp = $Mesh/TP
@onready var tptimer = $TPTimer
@onready var tptimerwait = $TPTimer.wait_time

@export var otherPortal : Node3D

var playerbody = null
var stateenter = 0

#stateenter = 0 -> enter portal
#stateenter = 1 -> exit portal

func _on_area_3d_body_entered(body):
	playerbody = body
	EnterPortal()

var scaleup = Vector3(1,1,1)
var scaledown = Vector3(0.01,0.01,0.01)
#var scaledown = Vector3(0.5,0.5,0.5)

func TurnOnTimer():
	tptimer.start()
	
	if stateenter == 1:
		create_tween().tween_property(playerbody, "scale", scaleup, tptimerwait)

func EnterPortal():
	TurnOnTimer()
	create_tween().tween_property(playerbody, "scale", scaledown, tptimerwait)
	playerbody.no_input = true

func _on_tp_timer_timeout():
	if stateenter == 0:
		playerbody.global_position = otherPortal.tp.global_position
		otherPortal.stateenter = 1
		
		otherPortal.playerbody = playerbody
		otherPortal.TurnOnTimer()
		playerbody = null
		
	else:
		playerbody.no_input = false
		stateenter = 0
		playerbody = null


#PORTAL PROCESS NOTES
	#ENTER CURR PORTAL
	#
	#turn on timer
	#scale down
	#turn off input
	#on timeout, position change
	#
	#MOVE TO OTHERPORTAL
	#
	#turn on timer
	#scale up
	#on timeout, turn on input
