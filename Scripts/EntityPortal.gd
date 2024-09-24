extends Node3D

@onready var tp = $Mesh/TP
@onready var tptimer = $TPTimer

@export var otherPortal : Node3D

var playerbody = null
var stateenter = 0
#stateenter = 0 -> enter portal
#stateenter = 1 -> exit portal

func _on_area_3d_body_entered(body):
	playerbody = body
	
	create_tween().tween_property(playerbody, "scale", Vector3(0.01,0.01,0.01), 0.5)
	playerbody.no_input = true
	otherPortal.stateenter = 1
	
	if otherPortal.tptimer.is_stopped():
		otherPortal.playerbody = playerbody
		playerbody = null
		otherPortal.tptimer.start()

func _on_tp_timer_timeout():
	if stateenter == 1:
		stateenter = 0
		
		playerbody.global_position = tp.global_position
		create_tween().tween_property(playerbody, "scale", Vector3(1,1,1), tptimer.wait_time/2)
		
		if tptimer.is_stopped():
			tptimer.start()
		
	else:
		playerbody.no_input = false
