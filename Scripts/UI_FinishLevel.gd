extends CanvasLayer

@onready var TrashCansUI = $Control/Panel/TrashCans

var currLevelId = Manager.LevelEntity.levelId

func _ready():
	if CheckMaxLevel() == true:
		HideNextLevel()
	
	TrashCansUI.levelId = Manager.LevelEntity.levelId
	TrashCansUI.Initialize()

func HideNextLevel():
	$Control/Panel/VBoxContainer/NextLevel.visible = false

func button_restart():
	Manager.ReqRestartLevel()

func button_mainmenu():
	Manager.ReqMainMenu()


func CheckMaxLevel():
	if currLevelId[1]+1 >= Manager.levelTimes[currLevelId[0]].size():
		return true
	return false

func button_nextlevel():
	if CheckMaxLevel() == false:
		Manager.ReqLevel([currLevelId[0], currLevelId[1]+1])
