extends Node

@onready var button_fullscreen = $Control/Menu/VBoxContainer/Fullscreen/Button
@onready var button_antialiasing = $Control/Menu/VBoxContainer/AntiAliasing/Button
@onready var button_vsync = $Control/Menu/VBoxContainer/Vsync/Button
@onready var button_objectcollision = $Control/GameSettings/ObjectCollision/Button

func _ready():
	if Manager.settings[3] == 1:
		if button_fullscreen.button_pressed == false:
			button_fullscreen.set_pressed_no_signal(true)
			button_fullscreen.Turn(true)
	
	if Manager.settings[4] == 1:
		if button_antialiasing.button_pressed == false:
			button_antialiasing.set_pressed_no_signal(true)
			button_antialiasing.Turn(true)
	
	if Manager.settings[5] == 1:
		if button_vsync.button_pressed == false:
			button_vsync.set_pressed_no_signal(true)
			button_vsync.Turn(true)
	
	if Manager.objectcollision == true:
		if button_objectcollision.button_pressed == false:
			button_objectcollision.set_pressed_no_signal(true)
			button_objectcollision.Turn(true)



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
	Manager.objectcollision = !Manager.objectcollision
	Manager.ReqRestartLevel()
