extends Control


signal restart_button()
signal continue_button()
@export var gm:GameManager
@export var gameUI:Control
@export var uiTransition : UITransition

func _ready():
	set_deferred("size", get_parent_control().size*2)
	set_deferred("position", Vector2(0,get_parent_control().size.y))
	gm.loseEvent.connect(lose)

func lose():
	gameUI.exit_screen().tween_callback(enter_screen)

func enter_screen():
	uiTransition.enter_screen()

func _restart_pressed():
	VisualTheme.instance.buttonPress.play()
	emit_signal("restart_button")
	VisualTheme.endlost()
	exit_screen().tween_callback(gameUI.enter_screen)

func _continue_pressed():
	VisualTheme.instance.buttonPress.play()
	gm.paused = false
	emit_signal("continue_button")
	VisualTheme.endlost()
	exit_screen().tween_callback(gameUI.enter_screen)

func exit_screen():
	return uiTransition.exit_screen()

func _menu_pressed():
	VisualTheme.instance.buttonPress.play()
	WorldPivotMover.instance.Leave()
	exit_screen().tween_callback(returnToMenu)

func returnToMenu():
	get_tree().change_scene_to_file("res://mainScenes/menu_scene.tscn")
	
