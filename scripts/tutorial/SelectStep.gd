extends TutorialStep
class_name SelectStep

@export var movesNeeded : Array[int]
@export var controls: TutorialControls
@export var textVariants: Array[String]

func Begin():
	controls.allowSelect = true
	controls.selectStep = self
	#turn on glow if needed
	for i in movesNeeded:
		pass #indicate tutorial spaces

func Check():
	if movesNeeded.size() == 0: End()

func End():
	controls.allowSelect = false
	controls.selectStep = null
	#activate timer if timer is not on
	#turn off glow if needed
	#end tutorial indicator
	super.End()

func GetText():
	return textVariants[controls.confirmSelect]
