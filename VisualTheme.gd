extends Node
class_name VisualTheme

static var instance : VisualTheme

signal win
signal endWon

func _ready():
	instance = self

static func won():
	instance.emit_signal("win")


static func endwon():
	instance.emit_signal("endWon")
