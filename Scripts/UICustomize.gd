extends VBoxContainer

var controllerid

func _ready():
	$ButtonColor.controllerid = controllerid
	$ButtonShape.controllerid = controllerid
	
	$ButtonColor.Initialize()
