extends Panel

@onready var buttonparent = $HBoxContainer

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
			var child = load("res://Prefabs/UI/ButtonColor.tscn").instantiate()
			child.controllerid = Manager.playerindex[i][2].controllerid
			buttonparent.add_child(child)

func _on_button_button_down():
	Turn()
