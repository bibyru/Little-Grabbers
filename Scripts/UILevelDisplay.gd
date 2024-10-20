extends Control

@export var levelid = "00"
@export var levelname = "wasd"

@onready var panel = $Panel
@onready var levelnamelabel = $Panel/Level/Label
@onready var photo = $Panel/Level/TextureRect
@onready var trashcans = $Panel/Level/TrashStars

var new_levelid

var normal_texture = load("res://Sauce/Theme/PanelLevelNormal.tres")
var hover_texture = load("res://Sauce/Theme/PanelLevelHover.tres")
var in_button = false

func _ready():
	TextureToNormal()
	
	var stagenum = levelid.to_int() / 10
	var levelnum = levelid.to_int() % 10
	new_levelid = [stagenum, levelnum]
	
	trashcans.levelid = new_levelid
	trashcans.Initialize()
	
	photo.texture = load("res://Sauce/GamePhotos/Levels-Level"+levelid+".JPG")
	levelnamelabel.text = levelname

func _on_button_button_down():
	Manager.ReqLevel(new_levelid)


func TextureToHover():
	panel.set("theme_override_styles/panel", hover_texture)
func TextureToNormal():
	panel.set("theme_override_styles/panel", normal_texture)

func _on_button_mouse_entered():
	TextureToHover()
func _on_button_mouse_exited():
	TextureToNormal()
