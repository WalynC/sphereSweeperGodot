extends Control

@export var gm : GameManager

signal new_game()
signal save_game()
signal load_game()
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	gm.connect("toggle_game_paused", _on_game_paused)
	self.connect("new_game", gm.reset_game)
	self.connect("save_game", SaveManager.save_data)
	self.connect("load_game", SaveManager.load_data)

func _on_new_game_pressed():
	emit_signal("new_game")
	
func _on_save_game_pressed():
	emit_signal("save_game")
	
func _on_load_game_pressed():
	emit_signal("load_game")

func _on_game_paused(is_paused : bool):
	print(is_paused)
	if (is_paused):
		show()
	else:
		hide()


func _on_button_pressed():
	gm.paused = false
