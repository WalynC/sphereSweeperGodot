extends Control


signal again_button()

@export var gm:GameManager
@export var time:Label
@export var bombs:Label

@export var gameUI:Control
@export var uiTransition : UITransition
@export var playAgainButton : Button
@export var playAgainText = "Play Again"

func _ready():
	set_deferred("size", get_parent_control().size*2)
	set_deferred("position", Vector2(0,get_parent_control().size.y))
	playAgainButton.text = playAgainText
	gm.winEvent.connect(win)

func win():
	gameUI.exit_screen().tween_callback(enter_screen)
	bombs.text = "Bombs Hit: "+str(gm.board.minesHit)
	time.text = "Time: "+(str(GameTimer.elapsed) if GameUI.secondsOnly else GameTimer.GetHMSString())
	
func enter_screen():
	uiTransition.enter_screen()

func _again_pressed():
	VisualTheme.instance.buttonPress.play()
	emit_signal("again_button")
	VisualTheme.endwon()
	exit_screen().tween_callback(gameUI.enter_screen)
	
func exit_screen():
	return uiTransition.exit_screen()

func toMainMenu():
	get_tree().change_scene_to_file("res://mainScenes/menu_scene.tscn")

func _menu_pressed():
	VisualTheme.instance.buttonPress.play()
	WorldPivotMover.instance.Leave()
	exit_screen().tween_callback(toMainMenu)
