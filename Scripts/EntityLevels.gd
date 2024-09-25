extends Node3D

var total_garbage
var finishlevel_timer


func _ready():
	Manager.score = 0
	Manager.levelentity = self
	
	total_garbage = get_tree().get_nodes_in_group("Garbage").size()

func GarbageRecycled():
	total_garbage -= 1
	
	if total_garbage < 1:
		FinishLevel()


func FinishLevel():
	finishlevel_timer = Timer.new()
	finishlevel_timer.one_shot = true
	finishlevel_timer.autostart = true
	finishlevel_timer.wait_time = 2
	finishlevel_timer.timeout.connect(timer_timeout)
	add_child(finishlevel_timer)

func timer_timeout():
	Manager.ReqMainMenu()
