extends CanvasLayer

@onready var trashcans = $Control/Panel/TrashCans

func _on_restart_button_down():
	Manager.ReqRestartLevel()

func _on_main_menu_button_down():
	Manager.ReqMainMenu()
