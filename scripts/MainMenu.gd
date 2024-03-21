extends Control


signal new_game_button()

	
@export var continueButton:Button
@export var basicGameUI:Control
@export var optionsMenuUI:Control
@export var mainMenuSphere : MeshInstance3D

func new_game_button_pressed():
	VisualTheme.instance.buttonPress.play()
	exit_screen().tween_callback(basicGameUI.enter_screen)
	
func options_button_pressed():
	VisualTheme.instance.buttonPress.play()
	exit_screen().tween_callback(optionsMenuUI.enter_screen)
	
func _ready():
	size = get_parent_control().size *2
	position = Vector2(0,get_parent_control().size.y)
	#load save, if there is a save, continue button should be enabled
	continueButton.disabled = !SaveManager.load_data()
	enter_screen()

func continue_game_pressed():
	VisualTheme.instance.buttonPress.play()
	exit_screen().tween_callback(continue_game)

func tutorial_button_pressed():
	GameManager.gameMode = 2
	VisualTheme.instance.buttonPress.play()
	exit_screen().tween_callback(tutorial)

func quit_game():
	get_tree().quit()

func tutorial():
	get_tree().change_scene_to_file("res://mainScenes/tutorial.tscn")

func continue_game():
	GameManager.loading = true
	get_tree().change_scene_to_file("res://mainScenes/game.tscn")

func enter_screen():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,0),.5)

func exit_screen():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,get_parent_control().size.y),.5)
	return tween
