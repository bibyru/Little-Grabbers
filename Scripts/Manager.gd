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



var playerindex = [[],[],[],[]]
var score = 0

var trashcans = [
	# Stage 0 (Testing)
	[0, "Virtual Angel"],
	
	# Stage 1 (Training Facility)
	[0,0],
	
	# Stage 2 (Classroom)
	[0]
]
var leveltimes = [
	# Stage 0 (Testing)
	[10, "Hi High"],
	
	# Stage 1 (Training Facility)
	[60, 100],
	
	# Stage 2 (Classroom)
	[120]
]
var scoretargets = [
	# Stage 0 (Testing)
	[[0, 5, 10], ["TTYL"]],
	
	# Stage 1 (Training Facility)
	# Level 0         Level 1
	[[45, 65, 120], [115, 135, 190]],
	
	# Stage 2 (Classroom)
	# Level 0
	[[12, 12, 12]]
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
var score_onesecond = 2


var settings = [10,50,100, 1,1,0]
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

func ReqLevel(levelid):
	if levelid[1] > 0 and trashcans[levelid[0]][levelid[1]-1] < 2:
		levelentity.CansWarning()
		return
	
	get_tree().paused = true
	get_tree().change_scene_to_file("res://Scenes/Level"+ str(levelid[0]) + str(levelid[1]) +".tscn")
	get_tree().paused = false

func ReqRestartLevel():
	get_tree().paused = true
	get_tree().reload_current_scene()
	
	if pausechild != null:
		itemspawner.remove_child(pausechild)
		pausechild = null
	get_tree().paused = false



func CheckInPlayer(player):
	for i in playerindex.size():
		if playerindex[i].is_empty():
			playerindex[i] = [player.playerid, "#bf77b9", player]
			print("success putting in player")
			break

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
