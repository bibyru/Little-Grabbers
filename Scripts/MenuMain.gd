extends Node

@onready var PanelColor = $CanvasLayer/Control/PanelColor
@onready var LevelSelect = $CanvasLayer/Control/LevelSelect

@onready var WarningPanel = $CanvasLayer/Control/Panel/VBoxContainer/ButtonManagePlayers/PanelPlayers/VBoxContainer/ButtonAddPlayer/WarningPanel
@onready var WarningPanelLabel = $CanvasLayer/Control/Panel/VBoxContainer/ButtonManagePlayers/PanelPlayers/VBoxContainer/ButtonAddPlayer/WarningPanel/Label
@onready var WarningTimer = $CanvasLayer/Control/Panel/VBoxContainer/ButtonManagePlayers/PanelPlayers/VBoxContainer/ButtonAddPlayer/WarningPanel/Timer

@onready var PlayerPanel = $CanvasLayer/Control/Panel/VBoxContainer/ButtonManagePlayers/PanelPlayers

@onready var CansPanel = $CanvasLayer/Control/LevelSelect/CansWarning
@onready var CansTimer = $CanvasLayer/Control/LevelSelect/CansWarning/Timer

var levelid = [0, 1]

func _ready():
	Manager.levelentity = self
	
	LevelSelect.visible = false
	PanelColor.visible = false
	PlayerPanel.visible = false
	
	WarningPanel.modulate = Color(1,1,1,0)
	CansPanel.modulate = Color(1,1,1,0)


func CansWarning():
	CansPanel.modulate = Color(1,1,1,1)
	if CansTimer.is_stopped():
		CansTimer.start()

func CansTimeout():
	create_tween().tween_property(CansPanel, "modulate", Color(1,1,1,0), 0.5)


func _on_button_play_button_down():
	if LevelSelect.visible == false:
		LevelSelect.visible = true
	else:
		LevelSelect.visible = false

func _on_button_color_button_down():
	PanelColor.Turn()

func _on_button_manage_players_button_down():
	if PlayerPanel.visible == false:
		PlayerPanel.visible = true
	else:
		PlayerPanel.visible = false

func _on_button_reset_players_button_down():
	for i in Manager.playerindex.size():
		Manager.playerindex[i] = []
	Manager.ReqRestartLevel()

func _on_button_options_button_down():
	Manager.PauseMenu()

func _on_button_delsave_button_down():
	Manager.DeleteSave()

func _on_hide_level_select_button_down():
	LevelSelect.visible = false



func PlayerWarning(given_text : String):
	WarningPanel.modulate = Color(1,1,1,1)
	WarningPanelLabel.text = given_text
	if WarningTimer.is_stopped():
		WarningTimer.start()

func _on_button_add_player_button_down():
	if !Manager.playerindex[3].is_empty():
		PlayerWarning("Max. 4 players!")
		return
	
	if Input.get_connected_joypads().size()+1 > Manager.playerindex.size():
		Manager.playerspawner.SpawnPlayer()
	else:
		PlayerWarning("Not enough controllers!")

func _on_warning_timer_timeout():
	create_tween().tween_property(WarningPanel, "modulate", Color(1,1,1,0), 0.5)



func _on_button_level0_down():
	Manager.ReqLevel([1,0])

func _on_button_level1_down():
	Manager.ReqLevel([1,1])
