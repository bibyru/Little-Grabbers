extends CanvasLayer

@onready var leveltimer = $Timer
@onready var timelabel = $Control/Panel/HBoxContainer/TimeLabel
@onready var scorename = $Control/Panel/HBoxContainer/Score
@onready var scorelabel = $Control/Panel/HBoxContainer/ScoreLabel

var level_time = 1

func _ready():
	Manager.gameui = self
	scorename.text = Manager.score_name
	scorelabel.text = "0000"
	CountTime()



func CountTime():
	if leveltimer.is_stopped():
		leveltimer.start()
		
		if !leveltimer.is_connected("timeout", CountTime):
			leveltimer.timeout.connect(CountTime)
	
	if level_time <= 0:
		Manager.levelentity.FinishLevel()
		return
	
	level_time -= 1
	var minute = level_time / 60
	var second = level_time % 60
	timelabel.text = "%02d:%02d" % [minute, second]



func UpdateScore(type : int):
	#type 0 = reward
	#type 1 = wrong
	#type 2 = reward 50%
	#type 9 = property
	#type 3 = add time score
	
	var old_score = Manager.score
	
	if type == 9:
		Manager.score -= Manager.score_property
	elif type == 0:
		Manager.score += Manager.score_reward
	elif type == 1:
		Manager.score -= Manager.score_punish
	elif type == 2:
		Manager.score += float(Manager.score_reward) / 2
	
	elif type == 3:
		Manager.score += level_time * Manager.score_onesecond
		leveltimer.stop()
		create_tween().tween_method(UpdateScoreLabel, old_score, Manager.score, 1.5)
		create_tween().tween_method(UpdateTimeLabel, level_time, 0, 1.5)
		return
	
	create_tween().tween_method(UpdateScoreLabel, old_score, Manager.score, 0.25)

func UpdateScoreLabel(score):
	scorelabel.text = "%04d" % [score]

func UpdateTimeLabel(time):
	timelabel.text = "%02d:%02d" % [time/60, time%60]
