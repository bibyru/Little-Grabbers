extends Control

@onready var PanelColor = $PanelColor
@onready var ControllerWarning = $Panel/VBoxContainer/ButtonAddPlayer/ControllerWarning
@onready var WarningTimer = $Panel/VBoxContainer/ButtonAddPlayer/ControllerWarning/Timer

func _ready():
	PanelColor.visible = false
	ControllerWarning.modulate = Color(1,1,1,0)

func _on_button_play_button_down():
	Manager.ReqNextLevel()

func _on_button_color_button_down():
	PanelColor.Turn()

func _on_button_options_button_down():
	Manager.PauseMenu()


func _on_button_add_player_button_down():
	if Input.get_connected_joypads().size()+1 > Manager.playerindex.size():
		Manager.playerspawner.SpawnPlayer()
	else:
		ControllerWarning.modulate = Color(1,1,1,1)
		if WarningTimer.is_stopped():
			WarningTimer.start()

func _on_warning_timer_timeout():
	create_tween().tween_property(ControllerWarning, "modulate", Color(1,1,1,0), 0.5)
