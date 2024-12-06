extends CanvasLayer

@onready var WarningTimer = $WarningTimer
@onready var WarningPanel = $Control/PropertyWarning
@onready var WarningLabel = $Control/PropertyWarning/Label

func _ready():
	WarningPanel.modulate = Color(1,1,1,0)

func WarnProp():
	WarningLabel.text = "Corporate property destroyed, %d %ss subtracted." %[Manager.scoreProperty, Manager.scoreName]
	StartWarning()

func StartWarning():
	WarningPanel.modulate = Color(1,1,1,1)
	if WarningTimer.is_stopped():
		WarningTimer.start()

func _on_warning_timer_timeout():
	create_tween().tween_property(WarningPanel, "modulate", Color(1,1,1,0), 0.2)
