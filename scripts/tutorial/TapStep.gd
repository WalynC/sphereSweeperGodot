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
		controls.tIndicator.Indicate(GameManager.instance.board.triangles[i])
		
func Check():
	if moves.size() == 0: End()

func EraseStep(index):
	moves.erase(index)

func End():
	controls.allowSelect = false
	controls.selectStep = null
	controls.tIndicator.EndIndicate()
	super.End()
