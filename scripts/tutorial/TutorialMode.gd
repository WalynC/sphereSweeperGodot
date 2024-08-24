extends Node
class_name TutorialMode

static var instance
var current = -1
var update = false
@export var steps : Array[Node]

@export var tutorialStepContainer : Node
@export var instructionsText : Label
@export var sIndicat: SelectIndicator
@export var tIndicat : TutorialIndicator
@export var controls : TutorialControls

@export var nextStepSound : AudioStreamPlayer
var animationList = []

func GetCurrentStep():
	if current == -1 || current >= steps.size(): return null
	return steps[current]

func Reset():
	GameUI.instance.flagButton.disabled = true
	GameUI.instance.neighborButton.disabled = true
	GameManager.instance.board.LoadPreset()
	sIndicat.EndIndicate()
	tIndicat.EndIndicate()
	controls.allowSelect = false
	controls.selectStep = null
	controls.tapStep = null
	controls.flag = false
	steps[current].Reset()
	current = -1
	controls.triangleHit = -999
	GameUI.instance.revealPanel.visible = true
	GameUI.instance.lockPanel.visible = false
	for i in animationList:
		i.stop()
	NextStep()

func _ready():
	GameUI.instance.flagButton.disabled = true
	GameUI.instance.neighborButton.disabled = true
	instance = self
	steps.resize(tutorialStepContainer.get_child_count())
	for i in range(steps.size()):
		steps[i]=tutorialStepContainer.get_child(i)
	#get list of animation players
	findByClass(get_tree().root, "AnimationPlayer", animationList)
	NextStep()

func findByClass(node, className, result):
	if (node.is_class(className)):
		result.push_back(node)
	for child in node.get_children():
		findByClass(child, className, result)

func NextStep():
	if (GetCurrentStep() != null && GetCurrentStep().playSoundOnCompletion): nextStepSound.play()
	current +=1
	if (current >= steps.size()):
		update = false
	else:
		steps[current].Begin()
		instructionsText.text = steps[current].GetText()
		update = steps[current].checkUpdate

func UpdateText():
	if current < steps.size() && current >= 0:
		instructionsText.text = steps[current].GetText()

func _process(_delta):
	if (update): steps[current].Check()
