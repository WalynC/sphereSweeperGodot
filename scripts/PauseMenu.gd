extends Control

@export var gm : GameManager

@export var gameUI : Control
@export var optionsUI : Control

signal new_game()

func _on_new_game_pressed():
	var tween = exit_screen()
	tween.tween_callback(newGameSignal)
	tween.tween_callback(gameUI.enter_screen)

func newGameSignal():
	emit_signal("new_game")
	
func go_to_main_menu():
	if (gm.board.boardGenerated):
		SaveManager.saveData.time = GameTimer.elapsed
		SaveManager.save_game()
	exit_screen().tween_callback(ToMenu)

func ToMenu():
	get_tree().change_scene_to_file("res://mainScenes/menu_scene.tscn")

func options_pressed():
	exit_screen().tween_callback(optionsUI.enter_screen)

func unpause():
	exit_screen().tween_callback(gameUI.enter_screen)

func enter_screen():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,0),.5)

func exit_screen():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,1024),.5)
	return tween
