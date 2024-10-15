extends HBoxContainer

var trashFalse = preload("res://Sauce/Sprites/TrashCan-False.png")
var trashTrue = preload("res://Sauce/Sprites/TrashCan-True.png")

@export var levelid = [12,12]
@export var manually_set_levelid = false

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
	if manually_set_levelid == true:
		Initialize()


func Initialize():
	ScoreTargets()
	CheckScore()

func ScoreTargets():
	for i in 3:
		scoretargetLabels[i].text = str(Manager.scoretargets[levelid[0]][levelid[1]][i])

func CheckScore():
	var trashcansgot = Manager.trashcans[levelid[0]][levelid[1]]
	
	if trashcansgot == 0:
		for i in 3:
			trashcanImages[i].texture = trashFalse
			trashcanImages[i].modulate = Color("#009999")
		
	else:
		for i in 3:
			if i < trashcansgot:
				trashcanImages[i].texture = trashTrue
				trashcanImages[i].modulate = Color("#00d9d9")
			else:
				trashcanImages[i].texture = trashFalse
				trashcanImages[i].modulate = Color("#009999")
