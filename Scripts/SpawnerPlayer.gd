extends Node3D

var player = preload("res://Prefabs/Entities/Player.tscn")

var needtospawn = 0

func _ready():
	Manager.playerspawner = self
	
	if Manager.playerindex[0].is_empty():
		SpawnPlayer()
	else:
		needtospawn = Manager.CheckPlayerCount()
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
	
	var player = player.instantiate()
	
	if type == 0:
		player.playerid = Manager.CheckPlayerCount()
		Manager.CheckInPlayer(player)
		
	elif type == 1:
		for playerdata in Manager.playerindex:
			
			if !playerdata.is_empty():
				if playerdata[2] == null:
					player.playerid = playerdata[0]
					playerdata[2] = player
					
					if needtospawn > 0:
						SpawnPlayer(1)
					break
			else:
				break
	
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
		  #spawned
		#+ set player.playerid
		#+ player.changecolor() -> already in player ready()
	#
	#TYPE = 2 (CANCELLED)
		#- player reconnects when joystick
		  #disconnected
		#+ wipe all player in tree
		#+ respawn according to playerindex.size
		#+ player.changecolor() -> already in player ready()
