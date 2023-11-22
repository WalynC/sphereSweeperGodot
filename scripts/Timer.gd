extends Node

class_name GameTimer

@export var gm: Node3D

static var elapsed = 0

func _process(delta):
	if (!gm.paused):
		if (gm.board.boardGenerated): elapsed += delta
	SaveManager.saveData.visualTime += delta

static func GetHMSString():
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
