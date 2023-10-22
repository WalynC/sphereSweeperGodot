extends Control


signal new_game_button()

func new_game_button_pressed():
	emit_signal("new_game_button")
