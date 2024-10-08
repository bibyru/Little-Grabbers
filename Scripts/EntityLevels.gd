extends Node3D

var FinishUI = preload("res://Prefabs/UI/UIFinishLevel.tscn")

var checkgarbage_timer = null
var finishlevel_timer = null

@export var levelid = [12, 12]

var scoretarget
@onready var GameUI = $GameUI

func _ready():
	Manager.levelentity = self
	Manager.score = 0
	
	scoretarget = Manager.scoretargets[levelid[0]][levelid[1]]
	
	var time = Manager.leveltimes[levelid[0]][levelid[1]]
	GameUI.level_time = time
	GameUI.timelabel.text = str("%02d:%02d" %[time/60, time%60])

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
	GameUI.UpdateScore(3)
	
	var trashcansgot = 0
	for i in 3:
		if Manager.score >= scoretarget[i]:
			trashcansgot += 1
		else:
			break
	
	Manager.trashcans[levelid[0]][levelid[1]] = trashcansgot
	
	finishlevel_timer = Timer.new()
	finishlevel_timer.one_shot = true
	finishlevel_timer.autostart = true
	finishlevel_timer.wait_time = 4
	finishlevel_timer.timeout.connect(SpawnFinishUI)
	add_child(finishlevel_timer)

func SpawnFinishUI():
	var finishui_child = FinishUI.instantiate()
	Manager.itemspawner.add_child(finishui_child)
