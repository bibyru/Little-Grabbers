extends VBoxContainer

var controllerId

func _ready():
	$ButtonColor.controllerId = controllerId
	$ButtonShape.controllerId = controllerId
	
	$ButtonColor.Initialize()
