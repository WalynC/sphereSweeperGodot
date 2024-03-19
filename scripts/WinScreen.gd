extends Control


signal again_button()

@export var gm:GameManager
@export var time:Label
@export var bombs:Label

@export var gameUI:Control

func _ready():
	size = get_parent_control().size *2
	position = Vector2(0,get_parent_control().size.y)
	gm.winEvent.connect(win)

func win():
	gameUI.exit_screen().tween_callback(enter_screen)
	bombs.text = "Bombs Hit: "+str(gm.board.minesHit)
	time.text = "Time: "+(str(GameTimer.elapsed) if GameUI.secondsOnly else GameTimer.GetHMSString())
	
func enter_screen():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,0),.5)

func _again_pressed():
	VisualTheme.instance.buttonPress.play()
	emit_signal("again_button")
	VisualTheme.endwon()
	exit_screen().tween_callback(gameUI.enter_screen)
	
func exit_screen():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,get_parent_control().size.y*2),.5)
	return tween

func toMainMenu():
	get_tree().change_scene_to_file("res://mainScenes/menu_scene.tscn")

func _menu_pressed():
	VisualTheme.instance.buttonPress.play()
	WorldPivotMover.instance.Leave()
	exit_screen().tween_callback(toMainMenu)
