extends TutorialStep
class_name SelectStep

@export var movesNeeded : Array[int]
@export var controls: TutorialControls
@export var textVariants: Array[String]

var moves : Array[int]
var playingAnim = false
var anim
var active = false

func Begin():
	active = true
	controls.allowSelect = true
	controls.selectStep = self
	moves = movesNeeded.duplicate()
	anim = GameUI.instance.confirmButton.get_node("AnimationPlayer")
	#turn on button glow if needed
	for i in moves:
		controls.tIndicator.Indicate(GameManager.instance.board.triangles[i])

func _process(delta):
	if (!active): return
	if (controls.triangleHit >= 0):
		if (!playingAnim):
			print("should be glowing")
			anim.play("glow")
			playingAnim = true
	else:
		anim.stop()
		playingAnim = false

func Check():
	if moves.size() == 0: End()

func End():
	active = false
	controls.allowSelect = false
	controls.selectStep = null
	playingAnim = false
	anim.stop()
	#activate timer if timer is not on
	#turn off glow if needed
	controls.tIndicator.EndIndicate()
	super.End()

func GetText():
	return textVariants[controls.confirmSelect]
