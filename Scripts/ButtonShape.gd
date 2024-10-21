extends OptionButton

var controllerid

func _on_item_selected(index):
	Manager.playerindex[controllerid][3] = index
	Manager.playerindex[controllerid][2].ChangeShape(index)
