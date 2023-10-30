extends Control


signal again_button()

@export var gm:GameManager
@export var time:RichTextLabel
@export var bombs:RichTextLabel

func _ready():
	hide()
	gm.winEvent.connect(win)

func win():
	show()
	bombs.text = "bombs hit: "+str(gm.board.minesHit)

func _again_pressed():
	emit_signal("again_button")

func _menu_pressed():
	get_tree().change_scene_to_file("res://menu_scene.tscn")
