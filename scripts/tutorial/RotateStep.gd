extends TutorialStep
class_name RotateStep

@export var pivot : Node3D
@export var angleReq : int = 60
var initial : Quaternion

func Begin():
	checkUpdate = true
	initial = pivot.quaternion

func Check():
	if (initial.angle_to(pivot.quaternion) > deg_to_rad(45)):End()
