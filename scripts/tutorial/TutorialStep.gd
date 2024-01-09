extends Node
class_name TutorialStep

var checkUpdate = false
@export var instructions:String
var playSoundOnCompletion = true

func Begin():
	print("begin")

func End():
	TutorialMode.instance.NextStep()

func Check():
	pass

func GetText():
	return instructions
