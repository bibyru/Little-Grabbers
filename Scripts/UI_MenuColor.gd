extends Control

var customizeUILoad = load("res://Prefabs/UI/UICustomize.tscn")

@onready var ButtonParent = $PanelColor/HBoxContainer

func Turn():
	visible = !visible
	CheckPlayers()

func DeleteChildren():
	for child in ButtonParent.get_children():
		ButtonParent.remove_child(child)

func CheckPlayers():
	DeleteChildren()
	for i in Manager.playerIndex.size():
		if !Manager.playerIndex[i].is_empty():
			
			var customizeUIChild = customizeUILoad.instantiate()
			customizeUIChild.controllerId = i
			ButtonParent.add_child(customizeUIChild)

func _on_button_button_down():
	Turn()
