extends Control

@export var densities: Array[Button]
@export var sizes: Array[Button]
var called = false

@export var mainMenuUI:Control
@export var customGameUI:Control
@export var uiTransition : UITransition

var color = [Color.GREEN, Color.YELLOW, Color.RED]

func _ready():
	set_deferred("size", get_parent_control().size*2)
	set_deferred("position", Vector2(0,get_parent_control().size.y))
	
func enter_screen():
	uiTransition.enter_screen()
	called = true
	var densVal = (GameManager.density/5)-1
	var sizeVal = (GameManager.size-3)/2
	#densities[densVal].button_pressed = true
	densities[densVal].self_modulate = color[densVal]
	#sizes[sizeVal].button_pressed = true
	sizes[sizeVal].self_modulate = color[sizeVal]
	called = false

func exit_screen():
	UserSettings.SaveBasicSettings()
	return uiTransition.exit_screen()

func _change_density(_toggle, density):
	GameManager.density = (density+1)*5
	if called: return
	VisualTheme.instance.buttonPress.play()
	called = true
	for i in range(0,3):
		densities[i].button_pressed = false
		densities[i].self_modulate = Color.WHITE
	#densities[density].button_pressed = true
	densities[density].self_modulate = color[density]
	called = false

func _change_size(_toggle, boardSize):
	GameManager.size = (boardSize*2)+3
	if called: return
	VisualTheme.instance.buttonPress.play()
	called = true
	for i in range(0,3):
		sizes[i].button_pressed = false
		sizes[i].self_modulate = Color.WHITE
	#sizes[boardSize].button_pressed = true
	sizes[boardSize].self_modulate = color[boardSize]
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
