extends Node

@onready var buttonfullscreen = $Control/Menu/VBoxContainer/Fullscreen/Button
@onready var buttonantialiasing = $Control/Menu/VBoxContainer/AntiAliasing/Button
@onready var buttonvsync = $Control/Menu/VBoxContainer/Vsync/Button

func _ready():
	if Manager.settings[3] == 1:
		if buttonfullscreen.button_pressed == false:
			buttonfullscreen.set_pressed_no_signal(true)
			buttonfullscreen.Turn(true)
	
	if Manager.settings[4] == 1:
		if buttonantialiasing.button_pressed == false:
			buttonantialiasing.set_pressed_no_signal(true)
			buttonantialiasing.Turn(true)
	
	if Manager.settings[5] == 1:
		if buttonvsync.button_pressed == false:
			buttonvsync.set_pressed_no_signal(true)
			buttonvsync.Turn(true)



func _on_button_resume_button_down():
	Manager.PauseMenu()

func _on_button_main_button_down():
	Manager.ReqMainMenu()



func button_fullscreen(toggled_on):
	Manager.SetFullscreen(toggled_on)

func button_antialiasing(toggled_on):
	Manager.SetAntiAliasing(toggled_on)

func button_vsync(toggled_on):
	Manager.SetVsync(toggled_on)
