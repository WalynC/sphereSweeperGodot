extends TutorialStep
class_name TapStep

@export var movesNeeded : Array[int]
@export var controls: TutorialControls

func Begin():
	controls.allowSelect = true
	controls.tapStep = self
	for i in movesNeeded:
		TutorialIndicator.tutorialInst.Indicate(GameManager.instance.board.triangles[i])
		
func Check():
	if movesNeeded.size() == 0: End()

func End():
	controls.allowSelect = false
	controls.selectStep = null
	TutorialIndicator.tutorialInst.EndIndicate()
	super.End()
