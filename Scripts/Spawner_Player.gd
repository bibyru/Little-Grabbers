extends Node3D

var player = preload("res://Prefabs/Entities/Player.tscn")

var playersToSpawn = 0

func _ready():
	Manager.PlayerSpawner = self
	
	if Manager.playerIndex[0].is_empty():
		SpawnPlayer()
	else:
		playersToSpawn = Manager.CheckPlayerCount()
		SpawnPlayer(1)



func SpawnPlayer(type = 0):
	if type == 0:
		playersToSpawn = 1
	
	var spawnTimer = Timer.new()
	spawnTimer.autostart = true
	spawnTimer.one_shot = true
	spawnTimer.wait_time = 0.3
	spawnTimer.timeout.connect(SpawnTimerTimeout.bind(spawnTimer, type))
	add_child(spawnTimer)

func SpawnTimerTimeout(spawnTimer, type):
	remove_child(spawnTimer)
	playersToSpawn -= 1
	
	var player = player.instantiate()
	
	if type == 0:
		player.playerId = Manager.CheckPlayerCount()
		Manager.CheckInPlayer(player)
		
	elif type == 1:
		for playerData in Manager.playerIndex:
			
			if !playerData.is_empty():
				if playerData[2] == null:
					player.playerId = playerData[0]
					playerData[2] = player
					
					if playersToSpawn > 0:
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
