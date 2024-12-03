extends Control

@onready var label = $Label
@onready var button = $ColorPickerButton

var controllerId

func Initialize():
	label.text = "Player %d" %[controllerId+1]
	button.color = Manager.playerIndex[controllerId][1]

func _on_color_picker_button_color_changed(color):
	Manager.playerIndex[controllerId][1] = color
	Manager.playerIndex[controllerId][2].ChangeColor()
