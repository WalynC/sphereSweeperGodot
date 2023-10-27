extends Control


signal new_game_button()

	
@export var continueButton:Button

func new_game_button_pressed():
	emit_signal("new_game_button")
	
func _ready():
	#load save
	SaveManager.load_data()
	#if there is a save, continue button should be enabled
	continueButton.disabled = SaveManager.saveData == null

func continue_game():
	GameManager.loading = true
	get_tree().change_scene_to_file("res://game.tscn")
