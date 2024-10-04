extends Node
class_name TutorialStep

var checkUpdate = false
@export var instructions:String
@export var playSoundOnCompletion = true

func Begin():
	pass

func End():
	TutorialMode.instance.NextStep()

func Reset():
	pass

func Check():
	pass

func GetText():
	return instructions
