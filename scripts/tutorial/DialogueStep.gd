extends TutorialStep
class_name DialogueStep

@export var button:Button
var anim

func Begin():
	anim = button.get_node("AnimationPlayer")
	if (!button.button_up.is_connected(End)): button.button_up.connect(End)
	button.show()
	anim.play("glow")

func Reset():
	button.button_up.disconnect(End)
	button.hide()
	anim.stop()

func End():
	Reset()
	super.End()
