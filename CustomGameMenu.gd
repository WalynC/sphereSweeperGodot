extends Control


signal back_button()
@export var densText: RichTextLabel
@export var sizeText: RichTextLabel

func _ready():
	hide()
	densText.text = str(GameManager.advDensity)
	sizeText.text = str(GameManager.advSize)

func _new_game_adv():
	GameManager.gameMode = 1
	get_tree().change_scene_to_file("res://game.tscn")
	
func back_button_pressed():
	emit_signal("back_button")

func density_changed(dens):
	GameManager.advDensity = int(dens)
	densText.text = str(GameManager.advDensity)
	
func size_changed(size):
	GameManager.advSize = int(size)
	sizeText.text = str(GameManager.advSize)
