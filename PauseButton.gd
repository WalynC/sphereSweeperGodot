extends Button

@export var gm : GameManager

func _on_pressed():
	gm.paused = true
