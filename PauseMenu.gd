extends Control

@export var gm : GameManager

signal new_game()
signal unpause_game()
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func _on_new_game_pressed():
	emit_signal("new_game")
	
func go_to_main_menu():
	if (gm.board.boardGenerated):
		SaveManager.saveData.time = GameTimer.elapsed
		SaveManager.save_game()
	get_tree().change_scene_to_file("res://menu_scene.tscn")

func unpause():
	gm.paused = false
	emit_signal("unpause_game")
