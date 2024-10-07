extends HBoxContainer

var trashFalse = preload("res://Sauce/Sprites/TrashCan-False.png")
var trashTrue = preload("res://Sauce/Sprites/TrashCan-True.png")

@export var stagenum : int = 0
@export var levelnum : int = 0

@onready var trashcanImages = [
	$VBoxContainer/TextureRect,
	$VBoxContainer2/TextureRect,
	$VBoxContainer3/TextureRect
]
@onready var scoretargetLabels = [
	$VBoxContainer/Label,
	$VBoxContainer2/Label,
	$VBoxContainer3/Label
]

func _ready():
	Initialize()

func SetLevelInfo(given_stagenum : int, given_levelnum : int):
	stagenum = given_stagenum
	levelnum = given_levelnum

func Initialize():
	ScoreTargets()
	CheckScore()

func ScoreTargets():
	for i in 3:
		scoretargetLabels[i].text = str(Manager.scoretargets[stagenum][levelnum][i])

func CheckScore():
	var trashcansgot = Manager.trashcans[stagenum][levelnum]
	
	if trashcansgot == 0:
		for i in 3:
			trashcanImages[i].texture = trashFalse
		
	else:
		for i in 3:
			if i < trashcansgot:
				trashcanImages[i].texture = trashTrue
			else:
				trashcanImages[i].texture = trashFalse
