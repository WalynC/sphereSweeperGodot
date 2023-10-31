extends Control


signal restart_button()
signal continue_button()
@export var gm:GameManager

func _ready():
	hide()
	gm.loseEvent.connect(lose)

func lose():
	show()

func _restart_pressed():
	emit_signal("restart_button")

func _continue_pressed():
	gm.paused = false
	emit_signal("continue_button")

func _menu_pressed():
	get_tree().change_scene_to_file("res://menu_scene.tscn")
