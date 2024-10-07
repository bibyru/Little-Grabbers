extends CanvasLayer

@onready var TrashCansUI = $Control/Panel/TrashCans

func _ready():
	TrashCansUI.levelid = Manager.levelentity.levelid
	TrashCansUI.Initialize()

func button_restart():
	Manager.ReqRestartLevel()

func button_mainmenu():
	Manager.ReqMainMenu()
