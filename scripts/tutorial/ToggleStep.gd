extends TutorialStep
class_name ToggleStep

@export var button : Button

func Begin():
	#play animation
	button.disabled = false
	button.button_up.connect(End)

func End():
	#stop animation
	button.disabled = true
	button.button_up.disconnect(End)
	super.End()
