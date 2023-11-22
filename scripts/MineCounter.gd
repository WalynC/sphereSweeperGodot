extends Button


@export var gm: Node3D
var useMines = false


func _process(delta):
	if useMines:
		text = str(gm.board.mines)
	else:
		text = str(gm.board.nonMines)


func _on_pressed():
	useMines = !useMines
