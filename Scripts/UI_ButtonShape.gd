extends OptionButton

var controllerId

func _on_item_selected(index):
	Manager.playerIndex[controllerId][3] = index
	Manager.playerIndex[controllerId][2].ChangeShape()
