extends Node
class_name VisualTheme

static var instance : VisualTheme

signal win
signal endWon
signal lose
signal endLose

@export var numberColors : Array[Color]
@export var theme : Theme

func LoadVisualTheme():
	instance = self
	VisualLoader.instance.controlRoot.theme = theme
	print("visual theme loaded")

static func won():
	instance.emit_signal("win")

static func endwon():
	instance.emit_signal("endWon")

static func lost():
	instance.emit_signal("lose")

static func endlost():
	instance.emit_signal("endLose")
