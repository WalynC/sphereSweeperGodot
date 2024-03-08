extends Node3D
class_name WorldPivotMover

static var instance
static var entered = false
# Called when the node enters the scene tree for the first time.
func _ready():
	entered = false
	instance = self
	var tween = create_tween()
	tween.tween_property(self, "position", Vector3(0,0,0),.5)
	tween.tween_callback(Finished)

func Finished():
	entered = true

func Leave():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector3(0,-20,0),.5)
