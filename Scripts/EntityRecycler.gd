extends StaticBody3D

var type = "wasd"

@onready var mesh = $Mesh
@onready var propwarning = $UIPropWarning

func _ready():
	add_to_group("Recycler")
	
	for i in Manager.garbage_types.size():
		if type == Manager.garbage_types[i]:
			mesh.set_surface_override_material(0, load(Manager.recycler_materials[i]))


func GarbageCheck(entity):
	if entity.is_in_group("Property") == true:
		Manager.gameui.UpdateScore(9)
		propwarning.WarnProp()
		return
	
	if entity.is_in_group("GarbageBlock"):
		if entity.type == type:
			Manager.gameui.UpdateScore(0)
		else:
			Manager.gameui.UpdateScore(1)
			
	elif entity.is_in_group("Garbage"):
		Manager.gameui.UpdateScore(1)
		Manager.gameui.UpdateScore(1)
	
	Manager.levelentity.GarbageRecycled()
