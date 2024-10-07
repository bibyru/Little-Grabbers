extends HBoxContainer

var trashFalse = preload("res://Sauce/Sprites/TrashCan-False.png")
var trashTrue = preload("res://Sauce/Sprites/TrashCan-True.png")


@export var stagenum : int
@export var levelnum : int
@export var trashcanImages : Array[TextureRect]

func _ready():
	CheckScore()


func CheckScore():
	var trashcansgot = Manager.trashcans[stagenum][levelnum]
	
	if trashcansgot == 0:
		for i in 3:
			trashcanImages[i].texture = trashFalse
		
	else:
		for i in 3:
			if i <= trashcansgot:
				trashcanImages[i].texture = trashTrue
			else:
				trashcanImages[i].texture = trashFalse
