extends Control

@export var densText: RichTextLabel
@export var sizeText: RichTextLabel
@export var densRange: Range
@export var sizeRange: Range

@export var basicGameUI:Control

func _ready():
	densText.text = str(GameManager.advDensity)
	sizeText.text = str(GameManager.advSize)
	densRange.value = GameManager.advDensity
	sizeRange.value = GameManager.advSize

func _new_game_adv():
	GameManager.gameMode = 1
	get_tree().change_scene_to_file("res://mainScenes/game.tscn")
	
func back_button_pressed():
	exit_screen().tween_callback(basicGameUI.enter_screen)

func density_changed(dens):
	GameManager.advDensity = int(dens)
	densText.text = str(GameManager.advDensity)
	
func size_changed(boardSize):
	GameManager.advSize = int(boardSize)
	sizeText.text = str(GameManager.advSize)

func enter_screen():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,0),.5)

func exit_screen():
	UserSettings.SaveCustomGameSettings()
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,1024),.5)
	return tween
