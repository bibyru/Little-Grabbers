extends Node3D

var FinishUI = preload("res://Prefabs/UI/UIFinishLevel.tscn")

var checkGarbageTimer = null
var finishLevelTimer = null

@export var levelId = [12, 12]

var scoreTarget
@onready var GameUI = $GameUI

var doHideNextLevel = false

# Level Requirements
	# level script
	# game ui
	#
	# player spawner
	# item spawner
	# recycler spawner
	#
	# level boundary (colshapes)
	# fall catcher

func _ready():
	Manager.LevelEntity = self
	Manager.score = 0
	
	scoreTarget = Manager.scoreTargets[levelId[0]][levelId[1]]
	
	var time = Manager.levelTimes[levelId[0]][levelId[1]]
	GameUI.levelTime = time
	GameUI.timeLabel.text = str("%02d:%02d" %[time/60, time%60])
	
	if Manager.musicTheme.playing == false:
		Manager.PlayMusicTheme()

func GarbageRecycled():
	if checkGarbageTimer != null:
		remove_child(checkGarbageTimer)
	
	checkGarbageTimer = Timer.new()
	checkGarbageTimer.one_shot = true
	checkGarbageTimer.autostart = true
	checkGarbageTimer.wait_time = 0.1
	checkGarbageTimer.timeout.connect(CheckGarbage)
	add_child(checkGarbageTimer)

func CheckGarbage():
	if get_tree().get_nodes_in_group("Garbage").size() == 0:
		if get_tree().get_nodes_in_group("GarbageBlock").size() == 0:
			FinishLevel()

func FinishLevel():
	for player in Manager.playerIndex:
		if !player.is_empty():
			player[2].doNoInput = true
	GameUI.UpdateScore(3)
	
	var trashcansgot = 0
	for i in 3:
		if Manager.score >= scoreTarget[i]:
			trashcansgot += 1
		else:
			break
	
	Manager.trashcans[levelId[0]][levelId[1]] = trashcansgot
	if Manager.trashcans[levelId[0]][levelId[1]] < 2:
		doHideNextLevel = true
	
	finishLevelTimer = Timer.new()
	finishLevelTimer.one_shot = true
	finishLevelTimer.autostart = true
	finishLevelTimer.wait_time = Manager.levelFinishTimer
	finishLevelTimer.timeout.connect(SpawnFinishUI)
	add_child(finishLevelTimer)
	
	Manager.musicTheme.stop()
	if GameUI.levelTime > 0:
		Manager.PlaySoundCountTime()

func SpawnFinishUI():
	var FinishUIChild = FinishUI.instantiate()
	Manager.ItemSpawner.add_child(FinishUIChild)
	if doHideNextLevel == true:
		FinishUIChild.HideNextLevel()
		Manager.PlayMusicLevel(false)
	else:
		Manager.PlayMusicLevel(true)
