extends Node

@onready var PanelColor = $CanvasLayer/Control/PanelColor
@onready var ControllerWarning = $CanvasLayer/Control/Panel/VBoxContainer/ButtonAddPlayer/ControllerWarning
@onready var WarningTimer = $CanvasLayer/Control/Panel/VBoxContainer/ButtonAddPlayer/ControllerWarning/Timer
@onready var LevelSelect = $CanvasLayer/Control/LevelSelect

func _ready():
	LevelSelect.visible = false
	PanelColor.visible = false
	ControllerWarning.modulate = Color(1,1,1,0)

func _on_button_play_button_down():
	LevelSelect.visible = true

func _on_button_color_button_down():
	PanelColor.Turn()

func _on_button_options_button_down():
	Manager.PauseMenu()

func _on_hide_level_select_button_down():
	LevelSelect.visible = false


func _on_button_add_player_button_down():
	if Input.get_connected_joypads().size()+1 > Manager.playerindex.size():
		Manager.playerspawner.SpawnPlayer()
	else:
		ControllerWarning.modulate = Color(1,1,1,1)
		if WarningTimer.is_stopped():
			WarningTimer.start()

func _on_warning_timer_timeout():
	create_tween().tween_property(ControllerWarning, "modulate", Color(1,1,1,0), 0.5)


func _on_button_level0_down():
	Manager.ReqLevel(0)

func _on_button_level1_down():
	Manager.ReqLevel(1)