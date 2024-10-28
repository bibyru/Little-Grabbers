extends Area3D

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if $Timer.is_stopped():
			$Timer.start()
			if $Timer.is_connected("timeout", Timer_Timeout) == false:
				$Timer.timeout.connect(Timer_Timeout.bind(body))
		
	else:
		body.global_position = Manager.itemspawner.global_position

func Timer_Timeout(body):
	body.global_position = Manager.playerspawner.global_position
	body.velocity.y = 0
