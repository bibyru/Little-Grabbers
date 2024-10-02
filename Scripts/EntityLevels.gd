extends Node3D

var checkgarbage_timer = null
var finishlevel_timer = null

@export var no_ui = false


func _ready():
	Manager.levelentity = self
	
	if no_ui == true:
		$GameUI.visible = false
		$Tutorial.visible = false

func GarbageRecycled():
	if checkgarbage_timer != null:
		remove_child(checkgarbage_timer)
	
	checkgarbage_timer = Timer.new()
	checkgarbage_timer.one_shot = true
	checkgarbage_timer.autostart = true
	checkgarbage_timer.wait_time = 0.1
	checkgarbage_timer.timeout.connect(CheckGarbage)
	add_child(checkgarbage_timer)

func CheckGarbage():
	if get_tree().get_nodes_in_group("Garbage").size() == 0:
		if get_tree().get_nodes_in_group("GarbageBlock").size() == 0:
			FinishLevel()

func FinishLevel():
	finishlevel_timer = Timer.new()
	finishlevel_timer.one_shot = true
	finishlevel_timer.autostart = true
	finishlevel_timer.wait_time = 2
	finishlevel_timer.timeout.connect(Manager.ReqMainMenu)
	add_child(finishlevel_timer)
