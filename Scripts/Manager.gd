extends Node

const garbage_types = [
	"Metal",
	"Organic",
	"Paper",
	"Plastic"
]
const recycler_materials = [
	"res://Sauce/Models/Recyclers/Recycler-Metal.tres",
	"res://Sauce/Models/Recyclers/Recycler-Organic.tres",
	"res://Sauce/Models/Recyclers/Recycler-Paper.tres",
	"res://Sauce/Models/Recyclers/Recycler-Plastic.tres"
]
const garbage_colors = [
	Color("#ff0000"),
	Color("#803300"),
	Color("#0000ff"),
	Color("ffff00")
]



var playerindex = []
var score = 0

var leveltimes = [
	# Stage 0 (Testing)
	[10],
	
	# Stage 1 (Training Facility)
	[60, 120]
]
var trashcans = [
	# Stage 0 (Testing)
	[0],
	
	# Stage 1 (Training Facility)
	[0,0]
]
var scoretargets = [
	# Stage 0 (Testing)
	[[0, 5, 10]],
	
	# Stage 1 (Training Facility)
	# Level 0
	[[90, 100, 150], [0]]
]



var playerspawner
var itemspawner

var levelentity
var pausechild
var gameui
var score_name = "Moula"
var score_reward = 10
var score_punish = 5
var score_property = 20
var score_onesecond = 5


var settings = [10,50,100, 1,0,0]
# settings[0] is master
# settings[1] is music
# settings[2] is sound
#
# settings[3] is fullscreen
# settings[4] is aa
# settings[5] is vsync

var savepath
# res://Output/Records.txt
# user://Records.txt

func _ready():
	get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _input(event):
	if event.is_action_pressed("Esc"):
		PauseMenu()



func ReqMainMenu():
	get_tree().paused = true
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	get_tree().paused = false

func ReqLevel(stagenum, levelnum):
	if levelnum > 0 and trashcans[stagenum][levelnum-1] < 2:
		levelentity.CansWarning()
		return
	
	get_tree().paused = true
	get_tree().change_scene_to_file("res://Scenes/Level"+ str(stagenum) + str(levelnum) +".tscn")
	get_tree().paused = false



func CheckInPlayer(player):
	playerindex.append([player.playerid, "#bf77b9", player])

func TrueIfUsed(id):
	for playerdata in playerindex:
		if playerdata[0] == id:
			return true
	return false



func PauseMenu():
	if pausechild == null:
		get_tree().paused = true
		pausechild = load("res://Scenes/PauseMenu.tscn").instantiate()
		itemspawner.add_child(pausechild)
	else:
		get_tree().paused = false
		itemspawner.remove_child(pausechild)
		pausechild = null



func SetFullscreen(booleah):
	if booleah == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		settings[3] = 1
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		settings[3] = 0

func SetAntiAliasing(booleah):
	if booleah == true:
		get_viewport().msaa_3d = Viewport.MSAA_8X
		settings[4] = 1
	else:
		get_viewport().msaa_3d = Viewport.MSAA_DISABLED
		settings[4] = 0

func SetVsync(booleah):
	if booleah == true:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
		settings[5] = 1
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		settings[5] = 0
