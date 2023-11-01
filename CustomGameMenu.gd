extends Control


signal back_button()
@export var densText: RichTextLabel
@export var sizeText: RichTextLabel
@export var densRange: Range
@export var sizeRange: Range

func _ready():
	hide()
	densText.text = str(GameManager.advDensity)
	sizeText.text = str(GameManager.advSize)
	densRange.value = GameManager.advDensity
	sizeRange.value = GameManager.advSize

func _new_game_adv():
	GameManager.gameMode = 1
	get_tree().change_scene_to_file("res://game.tscn")
	
func back_button_pressed():
	emit_signal("back_button")

func density_changed(dens):
	GameManager.advDensity = int(dens)
	densText.text = str(GameManager.advDensity)
	
func size_changed(boardSize):
	GameManager.advSize = int(boardSize)
	sizeText.text = str(GameManager.advSize)
