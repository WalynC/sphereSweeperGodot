extends Button

@export var controls: Node3D

func _process(delta):
	match controls.neighborSelect:
		0:
			text = "no neighbor"
		1:
			text = "once"
		2:
			text = "many"
	
