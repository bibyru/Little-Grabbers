extends CanvasLayer

@onready var TrashCansUI = $Control/Panel/TrashCans

var curr_levelid = Manager.levelentity.levelid

func _ready():
	if CheckMaxLevel() == true:
		HideNextLevel()
	
	TrashCansUI.levelid = Manager.levelentity.levelid
	TrashCansUI.Initialize()

func HideNextLevel():
	$Control/Panel/VBoxContainer/NextLevel.visible = false

func button_restart():
	Manager.ReqRestartLevel()

func button_mainmenu():
	Manager.ReqMainMenu()


func CheckMaxLevel():
	if curr_levelid[1]+1 >= Manager.leveltimes[curr_levelid[0]].size():
		return true
	return false

func button_nextlevel():
	if CheckMaxLevel() == false:
		Manager.ReqLevel([curr_levelid[0], curr_levelid[1]+1])
