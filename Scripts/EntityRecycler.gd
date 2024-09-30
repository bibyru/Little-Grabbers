extends StaticBody3D

var type = "wasd"

@onready var mesh = $Mesh
@onready var propwarning = $UIPropWarning

func _ready():
	add_to_group("Recycler")
	
	for i in Manager.garbage_types.size():
		if type == Manager.garbage_types[i]:
			mesh.set_surface_override_material(0, load(Manager.recycler_materials[i]))

func GarbageCheck(garbage, garbageholder):
	garbageholder.ObjectRemoved(true)
	
	if garbage.is_in_group("Property") == true:
		Manager.gameui.UpdateScore(9)
		propwarning.Warn()
		return
	
	if garbage.is_in_group("GarbageBlock"):
		if garbage.type == type:
			Manager.gameui.UpdateScore(0)
		else:
			Manager.gameui.UpdateScore(1)
			
	elif garbage.is_in_group("Garbage"):
		if garbage.type == type:
			Manager.gameui.UpdateScore(2)
		else:
			Manager.gameui.UpdateScore(1)
	
	Manager.levelentity.GarbageRecycled()
