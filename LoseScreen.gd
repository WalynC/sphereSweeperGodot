extends Control


signal restart_button()
signal continue_button()
@export var gm:GameManager
@export var gameUI:Control

func _ready():
	gm.loseEvent.connect(lose)

func lose():
	gameUI.exit_screen().tween_callback(enter_screen)

func enter_screen():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,0),.5)

func _restart_pressed():
	emit_signal("restart_button")
	exit_screen().tween_callback(gameUI.enter_screen)

func _continue_pressed():
	gm.paused = false
	emit_signal("continue_button")
	exit_screen().tween_callback(gameUI.enter_screen)

func exit_screen():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,1024),.5)
	return tween

func _menu_pressed():
	get_tree().change_scene_to_file("res://mainScenes/menu_scene.tscn")
