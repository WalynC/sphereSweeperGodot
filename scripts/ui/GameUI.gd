extends Control
class_name GameUI

@export var timerButton : Button
@export var neighborButton : Button
@export var mineButton : Button
@export var confirmButton : Button
@export var flagButton : Button
@export var gm : GameManager
@export var controls : Controls
@export var bombLabel : Label

@export var pauseScreen : Control
@export var tutorial : Control

@export var multiSelectOn : CompressedTexture2D
@export var multiSelectOff : CompressedTexture2D

@export var revealPanel : Panel
@export var lockPanel : Panel
@export var uiTransition : UITransition

static var useMines = false
static var secondsOnly = false

static var instance

signal pause_game()

func _ready():
	set_deferred("size", get_parent_control().size*2)
	set_deferred("position", Vector2(0,get_parent_control().size.y))
	instance = self
	confirmButton.visible = controls.confirmSelect == 2
	enter_screen()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#display time
	if (secondsOnly):
		timerButton.text = str(GameTimer.elapsed as int)
	else:
		timerButton.text = GameTimer.GetHMSString()
	#display neighbor select text
	match controls.neighborSelect:
		0:
			neighborButton.icon = multiSelectOff
			neighborButton.modulate = Color.WHITE
		1:
			neighborButton.icon = multiSelectOn
			neighborButton.modulate = Color.WHITE
		2:
			neighborButton.icon = multiSelectOn
			neighborButton.modulate = Color.GREEN
	#display mines
	if useMines:
		mineButton.text = str(gm.board.mines)
		bombLabel.text = "Bombs Left"
	else:
		mineButton.text = str(gm.board.nonMines)
		bombLabel.text = "Clears Left"
	#change confirm button behavior
	confirmButton.visible = controls.confirmSelect == 2
	confirmButton.disabled = controls.previousTriangleHit == -1
	if (controls.confirmDown): controls.confirmDown = !confirmButton.disabled

func enter_screen():
	uiTransition.enter_screen().tween_callback(unpause)

func unpause():
	if (tutorial != null): tutorial.visible = true
	gm.paused = false
	gm.controlBlocker.visible = false

func exit_screen():
	UserSettings.SaveGameUISettings()
	gm.paused = true
	return uiTransition.exit_screen()

func pause():
	if (tutorial != null): tutorial.visible = false
	VisualTheme.instance.buttonPress.play()
	gm.controlBlocker.visible = true
	exit_screen().tween_callback(pauseScreen.enter_screen)

func confirmDown():
	controls.confirmDown = true

func confirmUp():
	controls.confirmDown = false

func confirm():
	controls.Confirm()
	controls.confirmDown = false

func toggle_neighborSelect():
	VisualTheme.instance.buttonPress.play()
	controls.neighborSelect +=1
	controls.neighborSelect %= 3

func SetFlag(val):
	revealPanel.visible = !val
	lockPanel.visible = val
	VisualTheme.instance.buttonPress.play()
	controls.SetFlag(val)

func toggle_time_display():
	VisualTheme.instance.buttonPress.play()
	secondsOnly = !secondsOnly

func toggle_mine_display():
	VisualTheme.instance.buttonPress.play()
	useMines = !useMines
	bombLabel.text = "Bombs Left" if useMines else "Safe Spaces Left"
