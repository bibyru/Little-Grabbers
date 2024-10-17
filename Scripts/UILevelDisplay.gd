extends VBoxContainer

@export var levelid = "00"
@export var levelname = "wasd"
@onready var levelnamelabel = $Label
@onready var photo = $TextureRect

func _ready():
	photo.texture = load("res://Sauce/GamePhotos/Levels-Level"+levelid+".JPG")
	levelnamelabel.text = levelname

func _on_button_button_down():
	var stagenum = levelid.to_int() / 10
	var levelnum = levelid.to_int() % 10
	Manager.ReqLevel([stagenum, levelnum])
