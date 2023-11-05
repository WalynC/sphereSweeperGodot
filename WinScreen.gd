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
	emit_signal("again_button")
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,1024),.5)
	tween.tween_callback(gameUI.enter_screen)

func _menu_pressed():
	get_tree().change_scene_to_file("res://menu_scene.tscn")
