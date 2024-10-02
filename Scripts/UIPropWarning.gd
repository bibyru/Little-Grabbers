extends CanvasLayer

@onready var timer = $WarningTimer
@onready var panel = $Control/PropertyWarning
@onready var label = $Control/PropertyWarning/Label

func _ready():
	panel.modulate = Color(1,1,1,0)

func WarnProp():
	label.text = "Corporate property destroyed, %d %ss subtracted." %[Manager.score_property, Manager.score_name]
	StartWarning()

func StartWarning():
	panel.modulate = Color(1,1,1,1)
	if timer.is_stopped():
		timer.start()

func _on_warning_timer_timeout():
	create_tween().tween_property(panel, "modulate", Color(1,1,1,0), 0.2)
