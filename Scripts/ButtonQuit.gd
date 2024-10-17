extends Button

func _on_button_down():
	Manager.SaveData()
	get_tree().quit()
