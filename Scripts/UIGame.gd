extends CanvasLayer

@onready var scorename = $Control/Score
@onready var scorelabel = $Control/Score/Label

func _ready():
	Manager.gameui = self
	scorename.text = Manager.score_name
	scorelabel.text = "0000"

func UpdateScore(correct : bool, property = false):
	var old_score = Manager.score
	
	if property == true:
		Manager.score -= Manager.score_property
	elif correct == true:
		Manager.score += Manager.score_reward
	else:
		Manager.score -= Manager.score_punish
	
	create_tween().tween_method(UpdateLabel, old_score, Manager.score, 0.25)

func UpdateLabel(score):
	scorelabel.text = "%04d" % [score]
