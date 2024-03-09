extends TutorialStep
class_name SelectStep

@export var movesNeeded : Array[int]
@export var controls: TutorialControls
@export var textVariants: Array[String]

var moves : Array[int]

func Begin():
	controls.allowSelect = true
	controls.selectStep = self
	moves = movesNeeded.duplicate()
	print(moves)
	#turn on button glow if needed
	for i in moves:
		TutorialIndicator.tutorialInst.Indicate(GameManager.instance.board.triangles[i])

func Check():
	print(moves)
	if moves.size() == 0: End()

func End():
	controls.allowSelect = false
	controls.selectStep = null
	#activate timer if timer is not on
	#turn off glow if needed
	TutorialIndicator.tutorialInst.EndIndicate()
	super.End()

func GetText():
	return textVariants[controls.confirmSelect]
