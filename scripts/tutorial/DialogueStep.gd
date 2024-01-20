extends TutorialStep
class_name DialogueStep

@export var button:Button
var anim

func Begin():
	anim = button.get_node("AnimationPlayer")
	button.button_up.connect(End)
	button.show()
	anim.play("glow")
	

func End():
	button.button_up.disconnect(End)
	button.hide()
	anim.stop()
	super.End()
