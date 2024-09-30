extends CanvasLayer

@onready var scorename = $Control/Score
@onready var scorelabel = $Control/Score/Label

func _ready():
	Manager.gameui = self
	scorename.text = Manager.score_name
	scorelabel.text = "0000"

func UpdateScore(type : int):
	#type 0 = reward
	#type 1 = wrong
	#type 2 = reward 50%
	#type 9 = property
	
	var old_score = Manager.score
	
	if type == 9:
		Manager.score -= Manager.score_property
	elif type == 0:
		Manager.score += Manager.score_reward
	elif type == 1:
		Manager.score -= Manager.score_punish
	elif type == 2:
		Manager.score += float(Manager.score_reward) / 2
	
	create_tween().tween_method(UpdateLabel, old_score, Manager.score, 0.25)

func UpdateLabel(score):
	scorelabel.text = "%04d" % [score]
