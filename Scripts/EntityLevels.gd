extends Node3D

var checkgarbage_timer = null
var finishlevel_timer = null

@export var stagenum : int
@export var levelnum : int

var scoretarget
@onready var game_ui = $GameUI

func _ready():
	Manager.levelentity = self
	
	scoretarget = Manager.scoretargets[0][0]
	game_ui.level_time = Manager.leveltimes[stagenum][levelnum]

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
	for player in Manager.playerindex:
		player[2].no_input = true
	game_ui.UpdateScore(3)
	
	finishlevel_timer = Timer.new()
	finishlevel_timer.one_shot = true
	finishlevel_timer.autostart = true
	finishlevel_timer.wait_time = 5
	finishlevel_timer.timeout.connect(LevelEnd)
	add_child(finishlevel_timer)

func LevelEnd():
	var trashcansgot = 0
	for i in 3:
		if Manager.score >= scoretarget[i]:
			trashcansgot += 1
		else:
			break
	
	Manager.trashcans[stagenum][levelnum] = trashcansgot
	Manager.ReqMainMenu()
