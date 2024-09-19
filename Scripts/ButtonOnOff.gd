extends Button

func _on_toggled(toggled_on):
	Turn(toggled_on)

func Turn(booleah):
	if booleah == true:
		text = "  ON "
	else:
		text = " OFF "
