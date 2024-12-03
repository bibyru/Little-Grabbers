extends Control

@export var levelId = "00"
@export var levelName = "wasd"

@onready var BgPanel = $BgPanel
@onready var LevelNameLabel = $BgPanel/Level/Label
@onready var Photo = $BgPanel/Level/TextureRect
@onready var TrashcansUI = $BgPanel/Level/TrashStars

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
	LevelNameLabel.text = levelName

func _on_button_button_down():
	Manager.ReqLevel(newLevelId)


func TextureToHover():
	BgPanel.set("theme_override_styles/BgPanel", hoverTexture)
func TextureToNormal():
	BgPanel.set("theme_override_styles/BgPanel", normalTexture)

func _on_button_mouse_entered():
	TextureToHover()
func _on_button_mouse_exited():
	TextureToNormal()
