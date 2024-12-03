extends HBoxContainer

var trashFalse = preload("res://Sauce/Sprites/TrashCan-False.png")
var trashTrue = preload("res://Sauce/Sprites/TrashCan-True.png")

@export var levelId = [12,12]
@export var doAutoInitialize = false

@onready var trashcanImages = [
	$VBoxContainer/TextureRect,
	$VBoxContainer2/TextureRect,
	$VBoxContainer3/TextureRect
]
@onready var scoreTargetLabels = [
	$VBoxContainer/Label,
	$VBoxContainer2/Label,
	$VBoxContainer3/Label
]


func _ready():
	if doAutoInitialize == true:
		Initialize()


func Initialize():
	ScoreTargets()
	CheckScore()

func ScoreTargets():
	for i in 3:
		scoreTargetLabels[i].text = str(Manager.scoretargets[levelId[0]][levelId[1]][i])

func CheckScore():
	var trashcansgot = Manager.trashcans[levelId[0]][levelId[1]]
	
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
