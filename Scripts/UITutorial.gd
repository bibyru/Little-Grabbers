extends CanvasLayer

@onready var tipnumlabel = $Control/Control/Panel/Label
@onready var TipLabel = $Control/Control/Panel/VBoxContainer/TipLabel
@onready var TipLabel2 = $Control/Control/Panel/VBoxContainer/TipLabel2

var tips = [
	[
		"Look up the key bindings\nin the pause menu!",
		"(any type of controllers are usable)"
	],
	[
		"Pick up the Garbage, then put it into\nthe BreakItDowner (BID) machine!",
		"(to get more points)"
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
var maxindex

func _ready():
	maxindex = tips.size()
	NextTip()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		NextTip()

func _on_button_button_down():
	NextTip()

func NextTip():
	index += 1
	
	if index == maxindex:
		index = 0
	
	tipnumlabel.text = "Tip %d /%d" %[index+1, maxindex]
	TipLabel.text = tips[index][0]
	TipLabel2.text = tips[index][1]
