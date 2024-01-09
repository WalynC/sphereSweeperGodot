extends TutorialStep
class_name RotateStep

@export var pivot : Node3D
var angleReq = 45.0
var initial : Quaternion

func Begin():
	checkUpdate = true
	initial = pivot.quaternion

func Check():
	if (initial.angle_to(pivot.quaternion) > deg_to_rad(45)):End()
