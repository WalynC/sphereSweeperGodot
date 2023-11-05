extends Control


signal new_game_button()

	
@export var continueButton:Button
@export var basicGameUI:Control

func new_game_button_pressed():
	exit_screen().tween_callback(basicGameUI.enter_screen)
	
func _ready():
	#load save, if there is a save, continue button should be enabled
	continueButton.disabled = !SaveManager.load_data()
	enter_screen()

func continue_game_pressed():
	exit_screen().tween_callback(continue_game)

func continue_game():
	GameManager.loading = true
	get_tree().change_scene_to_file("res://game.tscn")

func enter_screen():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,0),.5)

func exit_screen():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,1024),.5)
	return tween
