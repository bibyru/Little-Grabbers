extends Area3D

@onready var point = $Point

func _ready():
	point.visible = false

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if $Timer.is_stopped():
			$Timer.start()
			if $Timer.is_connected("timeout", Timer_Timeout) == false:
				$Timer.timeout.connect(Timer_Timeout.bind(body))
		
	else:
		
		if point.position == Vector3():
			body.linear_velocity = Vector3()
			body.angular_velocity = Vector3()
			body.global_position = Manager.itemspawner.global_position
			return
			
		else:
			body.linear_velocity = Vector3()
			body.angular_velocity = Vector3()
			body.global_position = point.global_position

func Timer_Timeout(body):
	body.global_position = Manager.playerspawner.global_position
	body.velocity.y = 0
