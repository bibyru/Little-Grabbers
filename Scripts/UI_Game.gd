extends CanvasLayer

@onready var levelTimer = $Timer
@onready var timeLabel = $Control/Panel/HBoxContainer/TimeLabel
@onready var scoreName = $Control/Panel/HBoxContainer/Score
@onready var scoreLabel = $Control/Panel/HBoxContainer/ScoreLabel

var levelTime = 1

@onready var soundTimer8s = $SoundTimer8s

func _ready():
	Manager.GameUI = self
	scoreName.text = Manager.scoreName
	scoreLabel.text = "0000"
	CountTime()



func CountTime():
	if levelTimer.is_stopped():
		levelTimer.start()
		
		if !levelTimer.is_connected("timeout", CountTime):
			levelTimer.timeout.connect(CountTime)
	
	if levelTime <= 0:
		Manager.LevelEntity.FinishLevel()
		return
	
	levelTime -= 1
	var minute = levelTime / 60
	var second = levelTime % 60
	timeLabel.text = "%02d:%02d" % [minute, second]
	
	if levelTime == 8:
		soundTimer8s.play()



func UpdateScore(type : int):
	#type 0 = reward
	#type 1 = wrong
	#type 2 = reward 50%
	#type 9 = property
	#type 3 = add time score
	
	var oldScore = Manager.score
	
	if type == 9:
		Manager.score -= Manager.scoreProperty
	elif type == 0:
		Manager.score += Manager.scoreReward
	elif type == 1:
		Manager.score -= Manager.scorePunish
	elif type == 2:
		Manager.score += float(Manager.scoreReward) / 2
	
	elif type == 3:
		Manager.score += levelTime * Manager.scoreOneSecond
		levelTimer.stop()
		create_tween().tween_method(UpdateScoreLabel, oldScore, Manager.score, 1.5)
		create_tween().tween_method(UpdateTimeLabel, levelTime, 0, 1.5)
		return
	
	create_tween().tween_method(UpdateScoreLabel, oldScore, Manager.score, 0.25)

func UpdateScoreLabel(score):
	scoreLabel.text = "%04d" % [score]

func UpdateTimeLabel(time):
	timeLabel.text = "%02d:%02d" % [time/60, time%60]
