extends Node
class_name VisualTheme

static var instance : VisualTheme

signal win
signal endWon
signal lose
signal endLose

func _ready():
	instance = self

static func won():
	instance.emit_signal("win")

static func endwon():
	instance.emit_signal("endWon")

static func lost():
	instance.emit_signal("lose")

static func endlost():
	instance.emit_signal("endLose")
