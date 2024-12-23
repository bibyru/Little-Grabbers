extends Node

@onready var MenuColor = $CanvasLayer/Control/MenuColor
@onready var LevelSelect = $CanvasLayer/Control/LevelSelect

@onready var WarningPanel = $CanvasLayer/Control/Panel/VBoxContainer/ButtonManagePlayers/PanelPlayers/VBoxContainer/ButtonAddPlayer/WarningPanel
@onready var WarningPanelLabel = $CanvasLayer/Control/Panel/VBoxContainer/ButtonManagePlayers/PanelPlayers/VBoxContainer/ButtonAddPlayer/WarningPanel/Label
@onready var WarningTimer = $CanvasLayer/Control/Panel/VBoxContainer/ButtonManagePlayers/PanelPlayers/VBoxContainer/ButtonAddPlayer/WarningPanel/Timer

@onready var PlayerPanel = $CanvasLayer/Control/Panel/VBoxContainer/ButtonManagePlayers/PanelPlayers

@onready var CansPanel = $CanvasLayer/Control/LevelSelect/CansWarning
@onready var CansTimer = $CanvasLayer/Control/LevelSelect/CansWarning/Timer

var levelId = [0, 1]

func _ready():
	Manager.LevelEntity = self
	
	LevelSelect.visible = false
	MenuColor.visible = false
	PlayerPanel.visible = false
	
	WarningPanel.modulate = Color(1,1,1,0)
	CansPanel.modulate = Color(1,1,1,0)
	
	if Manager.musicTheme.playing == false:
		Manager.PlayMusicTheme()


func CansWarning():
	CansPanel.modulate = Color(1,1,1,1)
	if CansTimer.is_stopped():
		CansTimer.start()

func CansTimeout():
	create_tween().tween_property(CansPanel, "modulate", Color(1,1,1,0), 0.5)


func _on_button_play_button_down():
	if LevelSelect.visible == false:
		LevelSelect.visible = true
		PlayerPanel.visible = false
	else:
		LevelSelect.visible = false

func _on_button_color_button_down():
	MenuColor.Turn()

func _on_button_manage_players_button_down():
	if PlayerPanel.visible == false:
		PlayerPanel.visible = true
		LevelSelect.visible = false
	else:
		PlayerPanel.visible = false

func _on_button_reset_players_button_down():
	for i in Manager.playerIndex.size():
		Manager.playerIndex[i] = []
	Manager.ReqRestartLevel()

func _on_button_options_button_down():
	Manager.PauseMenu()

func _on_button_delsave_button_down():
	Manager.DeleteSave()

func _on_hide_level_select_button_down():
	LevelSelect.visible = false



func PlayerWarning(givenText : String):
	WarningPanel.modulate = Color(1,1,1,1)
	WarningPanelLabel.text = givenText
	if WarningTimer.is_stopped():
		WarningTimer.start()

func _on_button_add_player_button_down():
	if !Manager.playerIndex[3].is_empty():
		PlayerWarning("Max. 4 players!")
		return
	
	if Input.get_connected_joypads().size()+1 > Manager.CheckPlayerCount():
		Manager.PlayerSpawner.SpawnPlayer()
	else:
		PlayerWarning("Not enough controllers!")

func _on_warning_timer_timeout():
	create_tween().tween_property(WarningPanel, "modulate", Color(1,1,1,0), 0.5)



func _on_button_level0_down():
	Manager.ReqLevel([1,0])

func _on_button_level1_down():
	Manager.ReqLevel([1,1])
