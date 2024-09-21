extends StaticBody3D

var type = "wasd"

@onready var mesh = $Mesh

@onready var PropertyWarning = $CanvasLayer/Control/PropertyWarning
@onready var WarningLabel = $CanvasLayer/Control/PropertyWarning/Label
@onready var WarningTimer = $CanvasLayer/WarningTimer

func _ready():
	add_to_group("Recycler")
	
	WarningLabel.text = "Corporate property recycled, %ss subtracted." %[Manager.score_name]
	PropertyWarning.modulate = Color(1,1,1,0)
	
	for i in Manager.garbage_types.size():
		if type == Manager.garbage_types[i]:
			mesh.set_surface_override_material(0, load(Manager.recycler_materials[i]))

func GarbageCheck(garbage, garbageholder):
	garbageholder.ObjectRemoved(true)
	
	if garbage.is_in_group("Garbage") == false:
		Manager.gameui.UpdateScore(false, true)
		
		if WarningTimer.is_stopped():
			WarningTimer.start()
			PropertyWarning.modulate = Color(1,1,1,1)
		
		return
	
	if garbage.type == type:
		Manager.gameui.UpdateScore(true)
	else:
		Manager.gameui.UpdateScore(false)
	
	Manager.levelentity.GarbageRecycled()

func _on_warning_timer_timeout():
	create_tween().tween_property(PropertyWarning, "modulate", Color(1,1,1,0), 0.2)
