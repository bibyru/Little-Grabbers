extends Node3D

var grabbercube = preload("res://Prefabs/GrabberCube.tscn")

var needtospawn = -1

func _ready():
	Manager.playerspawner = self
	
	if Manager.playerindex.size() == 0:
		SpawnPlayer()
	else:
		needtospawn = Manager.playerindex.size()
		SpawnPlayer(1)



func SpawnPlayer(type = 0):
	if type == 0:
		needtospawn = 1
	
	var spawntimer = Timer.new()
	spawntimer.autostart = true
	spawntimer.one_shot = true
	spawntimer.wait_time = 0.3
	spawntimer.timeout.connect(SpawnTimerTimeout.bind(spawntimer, type))
	add_child(spawntimer)

func SpawnTimerTimeout(spawntimer, type):
	remove_child(spawntimer)
	needtospawn -= 1
	
	var player = grabbercube.instantiate()
	
	if type == 0:
		if Manager.playerindex.size() == 0:
			player.playerid = 0
		else:
			player.playerid = Manager.playerindex.size()
		
		Manager.CheckInPlayer(player)
		
	elif type == 1:
		var index = Manager.playerindex.size()-needtospawn-1
		player.playerid = Manager.playerindex[index][0]
		Manager.playerindex[index][2] = player
		if needtospawn > 0:
			SpawnPlayer(1)
	
	add_child(player)



#TYPES OF SPAWN
	#
	#TYPE = 0
		#- player spawned from when game starts
		  #or in main menu
		#+ append data to playerindex
			#* data = playerid, color, playerentity
	#
	#TYPE = 1
		#- player spawned every scene change
		#+ rewrite playerindex data with ones
		  #respawned
		#+ set player.playerid
		#+ player.changecolor() -> already in player ready()
	#
	#TYPE = 2 (CANCELLED)
		#- player reconnects when joystick
		  #disconnected
		#+ wipe all player in tree
		#+ respawn according to playerindex.size
		#+ player.changecolor() -> already in player ready()
