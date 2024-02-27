extends Node3D
class_name WorldPivotMover

static var instance
# Called when the node enters the scene tree for the first time.
func _ready():
	instance = self
	var tween = create_tween()
	tween.tween_property(self, "position", Vector3(0,0,0),.5)

func Leave():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector3(0,-20,0),.5)
