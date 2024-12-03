extends Node3D

@onready var Tp = $Mesh/TP
@onready var TpTimer = $TPTimer
@onready var TpTimerWait = $TPTimer.wait_time

@export var OtherPortal : Node3D

var playerBody = null
var stateEnter = 0

# stateEnter = 0 -> enter portal
# stateEnter = 1 -> exit portal

func _on_area_3d_body_entered(body):
	playerBody = body
	EnterPortal()

var scaleUp = Vector3(1,1,1)
var scaleDown = Vector3(0.01,0.01,0.01)
#var scaleDown = Vector3(0.5,0.5,0.5)

func TurnOnTimer():
	TpTimer.start()
	
	if stateEnter == 1:
		create_tween().tween_property(playerBody, "scale", scaleUp, TpTimerWait)

func EnterPortal():
	TurnOnTimer()
	create_tween().tween_property(playerBody, "scale", scaleDown, TpTimerWait)
	playerBody.doNoInput = true

func _on_tp_timer_timeout():
	if stateEnter == 0:
		playerBody.global_position = OtherPortal.Tp.global_position
		OtherPortal.stateEnter = 1
		
		OtherPortal.playerBody = playerBody
		OtherPortal.TurnOnTimer()
		playerBody = null
		
	else:
		playerBody.no_input = false
		stateEnter = 0
		playerBody = null


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
