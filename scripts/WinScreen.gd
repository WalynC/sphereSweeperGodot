extends Control


signal again_button()

@export var gm:GameManager
@export var time:RichTextLabel
@export var bombs:RichTextLabel

@export var gameUI:Control

func _ready():
	gm.winEvent.connect(win)

func win():
	gameUI.exit_screen().tween_callback(enter_screen)
	bombs.text = "bombs hit: "+str(gm.board.minesHit)
	
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
	tween.tween_property(self, "position", Vector2(0,1024),.5)
	return tween

func toMainMenu():
	get_tree().change_scene_to_file("res://mainScenes/menu_scene.tscn")
	

func _menu_pressed():
	VisualTheme.instance.buttonPress.play()
	exit_screen().tween_callback(toMainMenu)
