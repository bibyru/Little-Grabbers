extends Area3D

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.global_position = Manager.playerspawner.global_position
		
	else:
		body.global_position = Manager.itemspawner.global_position
