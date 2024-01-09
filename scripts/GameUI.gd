extends Control
class_name GameUI

@export var timerButton : Button
@export var neighborButton : Button
@export var mineButton : Button
@export var confirmButton : Button
@export var gm : GameManager
@export var controls : Controls

@export var pauseScreen : Control
@export var tutorial : Control

static var useMines = false
static var secondsOnly = false

signal pause_game()

func _ready():
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
			neighborButton.text = "no neighbor"
		1:
			neighborButton.text = "once"
		2:
			neighborButton.text = "many"
	#display mines
	if useMines:
		mineButton.text = str(gm.board.mines)
	else:
		mineButton.text = str(gm.board.nonMines)
	#change confirm button behavior
	confirmButton.visible = controls.confirmSelect == 2
	confirmButton.disabled = controls.previousTriangleHit == -1

func enter_screen():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,0),.5)
	tween.tween_callback(unpause)

func unpause():
	if (tutorial != null): tutorial.visible = true
	gm.paused = false
	gm.controlBlocker.visible = false

func exit_screen():
	UserSettings.SaveGameUISettings()
	gm.paused = true
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,1024),.5)
	return tween

func pause():
	if (tutorial != null): tutorial.visible = false
	VisualTheme.instance.buttonPress.play()
	gm.controlBlocker.visible = true
	exit_screen().tween_callback(pauseScreen.enter_screen)

func confirm():
	controls.Confirm()

func toggle_neighborSelect():
	VisualTheme.instance.buttonPress.play()
	controls.neighborSelect +=1
	controls.neighborSelect %= 3

func SetFlag(val):
	controls.SetFlag(val)

func toggle_time_display():
	VisualTheme.instance.buttonPress.play()
	secondsOnly = !secondsOnly

func toggle_mine_display():
	VisualTheme.instance.buttonPress.play()
	useMines = !useMines
