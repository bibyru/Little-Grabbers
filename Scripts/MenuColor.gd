extends Control

var uicustomize_load = load("res://Prefabs/UI/UICustomize.tscn")

@onready var buttonparent = $PanelColor/HBoxContainer

func Turn():
	visible = !visible
	CheckPlayers()

func DeleteChildren():
	for child in buttonparent.get_children():
		buttonparent.remove_child(child)

func CheckPlayers():
	DeleteChildren()
	for i in Manager.playerindex.size():
		if !Manager.playerindex[i].is_empty():
			
			var uicustomize_child = uicustomize_load.instantiate()
			uicustomize_child.controllerid = i
			buttonparent.add_child(uicustomize_child)

func _on_button_button_down():
	Turn()
