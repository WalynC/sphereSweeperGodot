extends TutorialStep
class_name ToggleStep

@export var whichToToggle : int #0 is flag, 1 is neighbor
var button
var anim

func Begin():
	match whichToToggle:
		0:
			button = GameUI.instance.flagButton
		1:
			button = GameUI.instance.neighborButton
	#play animation
	anim = button.get_node("AnimationPlayer")
	anim.play("glow")
	button.disabled = false
	button.button_up.connect(End)

func Reset():
	anim.stop()
	button.disabled = true
	button.button_up.disconnect(End)

func End():
	Reset()
	super.End()
