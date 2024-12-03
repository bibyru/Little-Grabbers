extends StaticBody3D

var type = "wasd"

@onready var RecyclerMesh = $Mesh
@onready var PropWarning = $UIPropWarning

func _ready():
	add_to_group("Recycler")
	
	for i in Manager.garbageTypes.size():
		if type == Manager.garbageTypes[i]:
			RecyclerMesh.set_surface_override_material(0, load(Manager.recyclerMaterials[i]))


func GarbageCheck(entity):
	if entity.is_in_group("Property") == true:
		Manager.GameUI.UpdateScore(9)
		PropWarning.WarnProp()
		return
	
	if entity.is_in_group("GarbageBlock"):
		if entity.type == type:
			Manager.GameUI.UpdateScore(0)
		else:
			Manager.GameUI.UpdateScore(1)
			
	elif entity.is_in_group("Garbage"):
		Manager.GameUI.UpdateScore(1)
		Manager.GameUI.UpdateScore(1)
	
	Manager.LevelEntity.GarbageRecycled()
