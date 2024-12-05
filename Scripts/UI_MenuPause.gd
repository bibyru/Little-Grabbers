extends Node

@onready var panels = [
	$Control/Menu/RightContainer/Settings,
	$Control/Menu/RightContainer/Gameplay,
	$Control/Menu/RightContainer/Controls
]

@onready var buttonFullscreen = $Control/Menu/RightContainer/Settings/Fullscreen/Button
@onready var buttonAntiAliasing = $Control/Menu/RightContainer/Settings/AntiAliasing/Button
@onready var buttonVsync = $Control/Menu/RightContainer/Settings/Vsync/Button
@onready var buttonObjectcollision = $Control/Menu/RightContainer/Gameplay/ObjectCollision/Button

@onready var volumeSliders = [
	$Control/Menu/RightContainer/Settings/MasterVol/HSlider,
	$Control/Menu/RightContainer/Settings/MusicVol/HSlider,
	$Control/Menu/RightContainer/Settings/SoundVol/HSlider
]

func _ready():
	panels[0].visible = true
	panels[1].visible = false
	panels[2].visible = false
	
	for i in 3:
		volumeSliders[i].value = Manager.settings[i]
	
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
	
	if Manager.objectCollision == true:
		if buttonObjectcollision.button_pressed == false:
			buttonObjectcollision.set_pressed_no_signal(true)
			buttonObjectcollision.Turn(true)



func _on_button_resume_button_down():
	Manager.PauseMenu()

func _on_button_main_button_down():
	Manager.ReqMainMenu()

func _on_button_restart_button_down():
	Manager.ReqRestartLevel()



func Pressed_Button_PanelSettings():
	for i in panels.size():
		if i == 0:
			panels[i].visible = true
		else:
			panels[i].visible = false

func Pressed_Button_PanelGameplay():
	for i in panels.size():
		if i == 1:
			panels[i].visible = true
		else:
			panels[i].visible = false

func Pressed_Button_PanelControls():
	for i in panels.size():
		if i == 2:
			panels[i].visible = true
		else:
			panels[i].visible = false



func Pressed_Button_Fullscreen(toggled_on):
	Manager.SetFullscreen(toggled_on)

func Pressed_Button_AntiAliasing(toggled_on):
	Manager.SetAntiAliasing(toggled_on)

func Pressed_Button_Vsync(toggled_on):
	Manager.SetVsync(toggled_on)



func Pressed_Button_ObjectCollision(toggled_on):
	Manager.objectCollision = !Manager.objectCollision
	Manager.ReqRestartLevel()



func SliderMaster_ValueChange(value):
	Manager.SetVolumeBus(Manager.busMaster, value)

func SliderMusic_ValueChange(value):
	Manager.SetVolumeBus(Manager.busMusic, value)

func SliderSound_ValueChange(value):
	Manager.SetVolumeBus(Manager.busSound, value)
