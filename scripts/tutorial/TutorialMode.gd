extends Node
class_name TutorialMode

static var instance
var current = -1
var update = false
@export var steps : Array[Node]

@export var tutorialStepContainer : Node

func _ready():
	instance = self
	steps.resize(tutorialStepContainer.get_child_count())
	for i in range(steps.size()):
		steps[i]=tutorialStepContainer.get_child(i)
	NextStep()

func NextStep():
	steps[0].Begin()
