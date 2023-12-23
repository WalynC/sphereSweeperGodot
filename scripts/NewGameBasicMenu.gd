extends Control

@export var densities: Array[Button]
@export var sizes: Array[Button]
var called = false

@export var mainMenuUI:Control
@export var customGameUI:Control

func enter_screen():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,0),.5)
	densities[(GameManager.density/5)-1].button_pressed = true
	sizes[(GameManager.size-3)/2].button_pressed = true

func exit_screen():
	UserSettings.SaveBasicSettings()
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,1024),.5)
	return tween

func _change_density(_toggle, density):
	VisualTheme.instance.buttonPress.play()
	if called: return
	called = true
	GameManager.density = (density+1)*5
	for i in range(0,3):
		densities[i].button_pressed = false
	densities[density].button_pressed = true
	called = false

func _change_size(_toggle, boardSize):
	VisualTheme.instance.buttonPress.play()
	if called: return
	called = true
	GameManager.size = (boardSize*2)+3
	for i in range(0,3):
		sizes[i].button_pressed = false
	sizes[boardSize].button_pressed = true
	called = false

func _new_game_basic():
	VisualTheme.instance.buttonPress.play()
	GameManager.gameMode = 0
	exit_screen().tween_callback(toGame)

func toGame():
	get_tree().change_scene_to_file("res://mainScenes/game.tscn")

func back_button_pressed():
	VisualTheme.instance.buttonPress.play()
	exit_screen().tween_callback(mainMenuUI.enter_screen)

func custom_button_pressed():
	VisualTheme.instance.buttonPress.play()
	exit_screen().tween_callback(customGameUI.enter_screen)
