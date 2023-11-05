extends Control

@export var densities: Array[Button]
@export var sizes: Array[Button]
var called = false

@export var mainMenuUI:Control
@export var customGameUI:Control

func enter_screen():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,0),.5)

func exit_screen():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,1024),.5)
	return tween

func _ready():
	densities[(GameManager.density/5)-1].button_pressed = true
	sizes[(GameManager.size-3)/2].button_pressed = true

func _change_density(_toggle, density):
	if called: return
	called = true
	GameManager.density = (density+1)*5
	for i in range(0,3):
		densities[i].button_pressed = false
	densities[density].button_pressed = true
	called = false

func _change_size(_toggle, boardSize):
	if called: return
	called = true
	GameManager.size = (boardSize*2)+3
	for i in range(0,3):
		sizes[i].button_pressed = false
	sizes[boardSize].button_pressed = true
	called = false

func _new_game_basic():
	GameManager.gameMode = 0
	get_tree().change_scene_to_file("res://game.tscn")

func back_button_pressed():
	exit_screen().tween_callback(mainMenuUI.enter_screen)

func custom_button_pressed():
	exit_screen().tween_callback(customGameUI.enter_screen)
