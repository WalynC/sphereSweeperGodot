extends Control

@export var densText: Label
@export var sizeText: Label
@export var densRange: Range
@export var sizeRange: Range

@export var basicGameUI:Control
@export var uiTransition : UITransition


func _ready():
	pass
	set_deferred("size", get_parent_control().size*2)
	set_deferred("position", Vector2(0,get_parent_control().size.y))
	densText.text = "Bomb Density: "+str(GameManager.advDensity)
	sizeText.text = "Size: "+str(GameManager.advSize)
	
func _new_game_adv():
	playButtonSound()
	GameManager.gameMode = 1
	exit_screen().tween_callback(toGame)
	
func toGame():
	get_tree().change_scene_to_file("res://mainScenes/game.tscn")
	
func back_button_pressed():
	playButtonSound()
	exit_screen().tween_callback(basicGameUI.enter_screen)

func playButtonSound():
	VisualTheme.instance.buttonPress.play()

func density_changed(dens):
	GameManager.advDensity = int(dens)
	densText.text = "Bomb Density: "+str(GameManager.advDensity)
	
func size_changed(boardSize):
	GameManager.advSize = int(boardSize)
	sizeText.text = "Size: "+str(GameManager.advSize)

func enter_screen():
	uiTransition.enter_screen()
	densRange.value = GameManager.advDensity
	sizeRange.value = GameManager.advSize

func exit_screen():
	UserSettings.SaveCustomGameSettings()
	return uiTransition.exit_screen()
