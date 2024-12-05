extends Control

@export var chosenCircle = 0
@export var chosenIcon = 0

var textureFill = load("res://Sauce/Sprites/Controller-CircleFill.png")
var textureCircle = load("res://Sauce/Sprites/Controller-Circle.png")

@onready var circles = $Circles.get_children()
@onready var icons = $Icons.get_children()

@export var reminderCircle = ["None", "Up", "Left", "Down", "Right"]
@export var reminderIcon = ["None", "L"]

func _ready():
	if chosenCircle == 0:
		for i in icons.size():
			if i == chosenIcon-1:
				icons[i].visible = true
		
		for circle in circles:
			circle.visible = false
		return
	
	for i in circles.size():
		if i == chosenCircle-1:
			circles[i].texture = textureFill
		else:
			circles[i].texture = textureCircle
	
	for chosenIcon in icons:
		chosenIcon.visible = false
