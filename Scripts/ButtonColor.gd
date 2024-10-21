extends Control

@onready var label = $Label
@onready var button = $ColorPickerButton

var controllerid

func Initialize():
	label.text = "Player %d" %[controllerid+1]
	button.color = Manager.playerindex[controllerid][1]

func _on_color_picker_button_color_changed(color):
	Manager.playerindex[controllerid][1] = color
	Manager.playerindex[controllerid][2].ChangeColor()
