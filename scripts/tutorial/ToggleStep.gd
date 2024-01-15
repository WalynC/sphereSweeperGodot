extends TutorialStep
class_name ToggleStep

@export var whichToToggle : int #0 is flag, 1 is neighbor
var button

func Begin():
	match whichToToggle:
		0:
			button = GameUI.instance.flagButton
		1:
			button = GameUI.instance.neighborButton
	#play animation
	button.disabled = false
	button.button_up.connect(End)

func End():
	#stop animation
	button.disabled = true
	button.button_up.disconnect(End)
	super.End()
