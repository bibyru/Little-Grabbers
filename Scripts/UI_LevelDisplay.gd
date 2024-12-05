extends Control

@export var levelId = "00"
@export var levelName : String = "wasd"

@onready var BgPanel = $Panel
@onready var LevelNameLabel = $Panel/Level/Label
@onready var Photo = $Panel/Level/TextureRect
@onready var TrashcansUI = $Panel/Level/TrashStars

var newLevelId

var normalTexture = load("res://Sauce/Theme/PanelLevelNormal.tres")
var hoverTexture = load("res://Sauce/Theme/PanelLevelHover.tres")

func _ready():
	TextureToNormal()
	
	var stageNumber = levelId.to_int() / 10
	var levelNumber = levelId.to_int() % 10
	newLevelId = [stageNumber, levelNumber]
	
	TrashcansUI.levelId = newLevelId
	TrashcansUI.Initialize()
	
	Photo.texture = load("res://Sauce/GamePhotos/Levels-Level"+levelId+".JPG")
	
	if levelName == "wasd":
		levelName = "Level " + str(newLevelId[1])
	LevelNameLabel.text = levelName

func _on_button_button_down():
	Manager.ReqLevel(newLevelId)


func TextureToHover():
	BgPanel.set("theme_override_styles/panel", hoverTexture)
func TextureToNormal():
	BgPanel.set("theme_override_styles/panel", normalTexture)

func _on_button_mouse_entered():
	TextureToHover()
func _on_button_mouse_exited():
	TextureToNormal()
