extends Control

@export_flags("Up", "Left", "Down", "Right") var chosenState = 0
@export_flags("L") var chosenIcon = 0

var textureFill = load("res://Sauce/Sprites/Controller-CircleFill.png")
var textureCircle = load("res://Sauce/Sprites/Controller-Circle.png")

@onready var circles = $Circles.get_children()
@onready var icons = $Icons.get_children()

func _ready():
	if chosenState == 0:
		for i in icons.size():
			if i == chosenIcon-1:
				icons[i].visible = true
		
		for circle in circles:
			circle.visible = false
		return
	
	for i in circles.size():
		if i == chosenState-1:
			circles[i].texture = textureFill
		else:
			circles[i].texture = textureCircle
	
	for chosenIcon in icons:
		chosenIcon.visible = false
