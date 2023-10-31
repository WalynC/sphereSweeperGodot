extends Button

class_name GameTimer

@export var gm: Node3D

static var elapsed = 0
var secondsOnly = true

func _process(delta):
	if (!gm.paused):
		if (gm.board.boardGenerated): elapsed += delta
	SaveManager.saveData.visualTime += delta
	if (secondsOnly):
		text = str(elapsed as int)
	else:
		text = GetHMSString()
		
func GetHMSString():
	var e := elapsed as int
	var s = ""
	var hours = e / 3600
	e -= hours * 3600
	var minutes = e / 60
	e -= minutes * 60
	if (hours > 0):
		s += str(hours) + ":"
		if (minutes < 10): s += "0"#add 0 to front of minutes if needed
	s += str(minutes) + ":"
	if (e < 10): s += "0" #add 0 to front of seconds if needed
	s += str(e)
	return s

func _on_pressed():
	secondsOnly = !secondsOnly
