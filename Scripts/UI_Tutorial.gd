extends CanvasLayer

@onready var HtpNumber = $Control/HtpControl/Panel/HtpNumber
@onready var HtpLabel = $Control/HtpControl/Panel/VBoxContainer/HtpLabel
@onready var HtpLabel2 = $Control/HtpControl/Panel/VBoxContainer/HtpLabel2
@onready var HtpHideLabel = $Control/HtpControl/ButtonHide/Label

@onready var AnimPlayer = $AnimationPlayer

var howToPlayTexts = [
	[
		"Look up the key bindings\nin the pause menu!",
		"(any type of controllers are usable)"
	],
	[
		"Pick up the Garbage, then put\nit into the BID machine!",
		"(the cyan machine with two holes)"
	],
	[
		"Pick up the Garbage Block, then put\nit into the same colored Recycler!",
		"(+%d %ss as reward)" %[Manager.score_reward, Manager.score_name]
	],
	[
		"If you put garbage into the wrong\nRecycler, you'll be fined!",
		"(-%d %ss as punishment)" %[Manager.score_punish, Manager.score_name]
	],
	[
		"If you can't reach something,\nuse the cyan Stool!",
		"(stools are corporate properties)"
	],
	[
		"Don't recycle corporate property\nor you'll be fined %d %ss!" %[Manager.score_property, Manager.score_name],
		"(corporate props have cyan stickers)"
	]
]
var index = -1
var maxIndex

var doHideHTP = false



func _ready():
	maxIndex = howToPlayTexts.size()
	NextHtp()

func _input(event):
	if event.is_action_pressed("ui_left"):
		PrevHtp()
	if event.is_action_pressed("ui_right"):
		NextHtp()

func PrevHtp():
	index -= 1
	UpdateHtp()

func NextHtp():
	index += 1
	UpdateHtp()

func UpdateHtp():
	if index >= maxIndex:
		index = 0
	elif index <= -1:
		index = maxIndex-1
	
	HtpNumber.text = "How To Play: %d /%d" %[index+1, maxIndex]
	HtpLabel.text = howToPlayTexts[index][0]
	HtpLabel2.text = howToPlayTexts[index][1]



func _on_button_hide_button_down():
	if doHideHTP == false:
		doHideHTP = true
		AnimPlayer.play("HtpPanelExit")
		HtpHideLabel.text = "How To Play"
		return
	
	doHideHTP = false
	AnimPlayer.play("HtpPanelEnter")
	AnimPlayer.queue("HtpPanelBounce")
	HtpHideLabel.text = "Hide"
