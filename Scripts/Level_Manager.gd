extends Node

const garbageTypes = [
	"Metal",
	"Organic",
	"Paper",
	"Plastic"
]
const recyclerMaterials = [
	"res://Sauce/Models/Recyclers/Recycler-Metal.tres",
	"res://Sauce/Models/Recyclers/Recycler-Organic.tres",
	"res://Sauce/Models/Recyclers/Recycler-Paper.tres",
	"res://Sauce/Models/Recyclers/Recycler-Plastic.tres"
]
const garbageColors = [
	Color("#ff0000"),
	Color("#803300"),
	Color("#0000ff"),
	Color("ffff00")
]


const garbyShapes = [
	"Cube",
	"Triangle",
	"Circle"
]


var settings = [10,50,100, 1,1,0]
# settings[0] is master
# settings[1] is music
# settings[2] is sound
#
# settings[3] is fullscreen
# settings[4] is aa
# settings[5] is vsync

var objectCollision = false

#const savePath = "res://Output/savedata.ini"
const savePath = "user://savedata.ini"



var playerIndex = [[],[],[],[]]
var score = 0

var trashcans = [
	# Stage 0 (Testing)
	[0, "Virtual Angel"],
	
	# Stage 1 (Training Facility)
	[0,0,0],
	
	# Stage 2 (Classroom)
	[0,0,0]
]
var levelTimes = [
	# Stage 0 (Testing)
	[120, "Hi High"],
	
	# Stage 1 (Training Facility)
	[60, 60, 70],
	
	# Stage 2 (Factory)
	[150, 120, 120]
]
var scoreTargets = [
	# Stage 0 (Testing)
	[[0, 5, 10], ["TTYL"]],
	
	# Stage 1 (Training Facility)
	# Level 0         Level 1         Level 2
	[[90, 110, 135], [110, 120, 150], [90, 110, 135]],
	
	# Stage 2 (Factory)
	# Level 0
	[[110, 130, 150], [12, 12, 12], [12, 12, 12]]
]



var PlayerSpawner
var ItemSpawner

var LevelEntity
var PauseChild
var GameUI
var scoreName = "Moula"
var scoreReward = 10
var scorePunish = 5
var scoreProperty = 20
var scoreOneSecond = 2

var levelFinishTimer = 3

@onready var musicTheme = $MusicTheme
@onready var musicLevelSuccess = $MusicLevelSuccess
@onready var musicLevelFailed = $MusicLevelFailed
@onready var soundCountTime = $SoundCountTime

var busMaster = AudioServer.get_bus_index("Master")
var busMusic = AudioServer.get_bus_index("Music")
var busSound = AudioServer.get_bus_index("Sound")
var allBus = [busMaster, busMusic, busSound]



func _ready():
	get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	LoadData()
	
	if settings[3] == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	for i in 3:
		SetVolumeBus(i, settings[i])

func _input(event):
	if event.is_action_pressed("Esc"):
		PauseMenu()
	
	if event.is_action_pressed("InputTest"):
		pass



func SetTrashcansIni():
	var trashcansInitial = trashcans
	for i in trashcansInitial.size():
		for j in trashcansInitial[i].size():
			trashcansInitial[i][j] = 0
	return trashcansInitial

func SetSettingsIni():
	var settingsInitial = [10,50,100, 1,1,0]
	return settingsInitial

func FillTrashcans(trashcansBuffer):
	for i in trashcans.size():
		for j in trashcans[i].size():
			trashcansBuffer[i][j] = trashcans[i][j]
	return trashcansBuffer

func SaveData():
	get_tree().paused = true
	var config = ConfigFile.new()
	
	config.set_value("Game", "trashcans", trashcans)
	config.set_value("Settings", "settings", settings)
	config.set_value("GameSettings", "objectCollision", objectCollision)
	
	config.save(savePath)
	get_tree().paused = false

func LoadData():
	get_tree().paused = true
	
	var config = ConfigFile.new()
	config.load(savePath)
	
	var settingsInitial = SetSettingsIni()
	settings = config.get_value("Settings", "settings", settings)
	
	var objectCollisionInitial = false
	objectCollision = config.get_value("GameSettings", "objectCollision", objectCollisionInitial)
	
	var trashcansInitial = SetTrashcansIni()
	trashcans = config.get_value("Game", "trashcans", trashcansInitial)
	
	# to check if save is outdated, check trashcans size and its stage size
	var firstCheckPass = false
	if trashcans.size() != trashcansInitial.size():
		trashcans = FillTrashcans(trashcansInitial)
	else:
		firstCheckPass = true
	
	if firstCheckPass == true:
		for i in trashcans.size():
			if trashcans[i].size() != trashcansInitial[i].size():
				trashcans = FillTrashcans(trashcansInitial)
				break
	
	get_tree().paused = false

func DeleteSave():
	get_tree().paused = true
	
	var config = ConfigFile.new()
	
	var trashcansInitial = SetTrashcansIni()
	config.set_value("Game", "trashcans", trashcansInitial)
	
	get_tree().paused = false
	ReqRestartLevel()



func ReqMainMenu():
	get_tree().paused = true
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	get_tree().paused = false

func ReqLevel(levelId):
	if levelId[1] > 0 and trashcans[levelId[0]][levelId[1]-1] < 2:
		LevelEntity.CansWarning()
		return
	
	get_tree().paused = true
	get_tree().change_scene_to_file("res://Scenes/Level"+ str(levelId[0]) + str(levelId[1]) +".tscn")
	get_tree().paused = false

func ReqRestartLevel():
	get_tree().paused = true
	get_tree().reload_current_scene()
	
	if PauseChild != null:
		ItemSpawner.remove_child(PauseChild)
		PauseChild = null
	get_tree().paused = false



func CheckInPlayer(player):
	for i in playerIndex.size():
		if playerIndex[i].is_empty():
			playerIndex[i] = [player.playerId, "#9b9b9b", player, 0]
			break
		
		## Comment below if don't need to initialize others' colors
		#else:
			#var randomColor = ["#4190ff", "#ff9741", "#d8ff41", "#8d41ff"]
			#playerIndex[i] = [player.playerId, randomColor[randi_range(0, 3)], player, 0]

func CheckPlayerCount():
	var count = 0
	for i in playerIndex.size():
		if !playerIndex[i].is_empty():
			count += 1
		else:
			break
	return count

func TrueIfUsed(id):
	for playerData in playerIndex:
		if playerData[0] == id:
			return true
	return false



func PauseMenu():
	if PauseChild == null:
		get_tree().paused = true
		PauseChild = load("res://Scenes/PauseMenu.tscn").instantiate()
		ItemSpawner.add_child(PauseChild)
	else:
		get_tree().paused = false
		ItemSpawner.remove_child(PauseChild)
		PauseChild = null



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



func SetVolumeBus(busId : int, value : int):
	AudioServer.set_bus_volume_db(busId, linear_to_db(value * 0.01))
	settings[busId] = value
	SaveData()

func PlayMusicLevel(success : bool):
	if success == true:
		musicLevelSuccess.play()
	else:
		musicLevelFailed.play()

func PlayMusicTheme():
	musicTheme.play()
	if musicLevelFailed.playing == true:
		musicLevelFailed.stop()
	if musicLevelSuccess.playing == true:
		musicLevelSuccess.stop()

func PlaySoundCountTime():
	soundCountTime.play()
