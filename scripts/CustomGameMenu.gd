extends Control

@export var densText: Label
@export var sizeText: Label
@export var densRange: Range
@export var sizeRange: Range

@export var basicGameUI:Control


func _new_game_adv():
	VisualTheme.instance.buttonPress.play()
	GameManager.gameMode = 1
	exit_screen().tween_callback(toGame)
	
func toGame():
	get_tree().change_scene_to_file("res://mainScenes/game.tscn")
	
func back_button_pressed():
	VisualTheme.instance.buttonPress.play()
	exit_screen().tween_callback(basicGameUI.enter_screen)

func density_changed(dens):
	VisualTheme.instance.buttonPress.play()
	GameManager.advDensity = int(dens)
	densText.text = str(GameManager.advDensity)
	
func size_changed(boardSize):
	VisualTheme.instance.buttonPress.play()
	GameManager.advSize = int(boardSize)
	sizeText.text = str(GameManager.advSize)

func enter_screen():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,0),.5)
	densText.text = str(GameManager.advDensity)
	sizeText.text = str(GameManager.advSize)
	densRange.value = GameManager.advDensity
	sizeRange.value = GameManager.advSize

func exit_screen():
	UserSettings.SaveCustomGameSettings()
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,1024),.5)
	return tween
