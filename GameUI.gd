extends Control

@export var timerButton : Button
@export var neighborButton : Button
@export var mineButton : Button
@export var confirmButton : Button
@export var gm : GameManager
@export var controls : Controls

var useMines = false
var secondsOnly = false

func _ready():
	confirmButton.visible = controls.confirmSelect == 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	confirmButton.disabled = controls.previousTriangleHit == -1

func pause():
	gm.paused = true

func confirm():
	controls.Confirm()

func toggle_neighborSelect():
	controls.neighborSelect +=1
	controls.neighborSelect %= 3

func SetFlag(val):
	controls.SetFlag(val)

func toggle_time_display():
	secondsOnly = !secondsOnly

func toggle_mine_display():
	useMines = !useMines
