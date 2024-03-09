extends TutorialStep
class_name TapStep

@export var movesNeeded : Array[int]
@export var controls: TutorialControls

var moves : Array[int]

func Begin():
	controls.allowSelect = true
	controls.tapStep = self
	moves = movesNeeded.duplicate()
	for i in movesNeeded:
		TutorialIndicator.tutorialInst.Indicate(GameManager.instance.board.triangles[i])
		
func Check():
	if moves.size() == 0: End()

func End():
	controls.allowSelect = false
	controls.selectStep = null
	TutorialIndicator.tutorialInst.EndIndicate()
	super.End()
