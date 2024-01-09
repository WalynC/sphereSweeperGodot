extends TutorialStep
class_name DialogueStep

@export var button:Button

func Begin():
	button.button_up.connect(End)

func End():
	button.button_up.disconnect(End)
	super.End()
