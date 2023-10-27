extends Control

@export var gm : GameManager

signal new_game()
signal unpause_game()
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	gm.connect("toggle_game_paused", _on_game_paused)

func _on_new_game_pressed():
	emit_signal("new_game")
	
func go_to_main_menu():
	SaveManager.saveData.time = GameTimer.elapsed
	SaveManager.save_data()
	get_tree().change_scene_to_file("res://menu_scene.tscn")

func _on_game_paused(is_paused : bool):
	print(is_paused)
	if (is_paused):
		show()
	else:
		hide()


func unpause():
	gm.paused = false
	emit_signal("unpause_game")
