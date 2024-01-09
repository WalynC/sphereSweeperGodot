extends TutorialStep
class_name TapStep

@export var movesNeeded : Array[int]
@export var controls: TutorialControls

func Begin():
	controls.allowSelect = true
	controls.tapStep = self
	for i in movesNeeded:
		pass #indicate tutorial spaces
		
func Check():
	if movesNeeded.size() == 0: End()

func End():
	controls.allowSelect = false
	controls.selectStep = null
	#end tutorial indicator
	super.End()
