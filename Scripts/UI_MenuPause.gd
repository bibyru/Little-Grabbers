extends Node

@onready var buttonFullscreen = $Control/Menu/VBoxContainer/Fullscreen/Button
@onready var buttonAntiAliasing = $Control/Menu/VBoxContainer/AntiAliasing/Button
@onready var buttonVsync = $Control/Menu/VBoxContainer/Vsync/Button
@onready var buttonObjectcollision = $Control/GameSettings/ObjectCollision/Button

func _ready():
	if Manager.settings[3] == 1:
		if buttonFullscreen.button_pressed == false:
			buttonFullscreen.set_pressed_no_signal(true)
			buttonFullscreen.Turn(true)
	
	if Manager.settings[4] == 1:
		if buttonAntiAliasing.button_pressed == false:
			buttonAntiAliasing.set_pressed_no_signal(true)
			buttonAntiAliasing.Turn(true)
	
	if Manager.settings[5] == 1:
		if buttonVsync.button_pressed == false:
			buttonVsync.set_pressed_no_signal(true)
			buttonVsync.Turn(true)
	
	if Manager.objectcollision == true:
		if buttonObjectcollision.button_pressed == false:
			buttonObjectcollision.set_pressed_no_signal(true)
			buttonObjectcollision.Turn(true)



func _on_button_resume_button_down():
	Manager.PauseMenu()

func _on_button_main_button_down():
	Manager.ReqMainMenu()

func _on_button_restart_button_down():
	Manager.ReqRestartLevel()



func Pressed_Button_Fullscreen(toggled_on):
	Manager.SetFullscreen(toggled_on)

func Pressed_Button_AntiAliasing(toggled_on):
	Manager.SetAntiAliasing(toggled_on)

func Pressed_Button_Vsync(toggled_on):
	Manager.SetVsync(toggled_on)



func Pressed_Button_ObjectCollision(toggled_on):
	Manager.objectCollision = !Manager.objectCollision
	Manager.ReqRestartLevel()
