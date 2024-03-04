extends Node
class_name WindSound

static var instance : WindSound
@export var source : AudioStreamPlayer
var speed = 0.0
var decel = 1.0

func _ready():
	instance = self

func Spin(_speed, _decel, clampSpeedToHighest = false):
	if (clampSpeedToHighest): _speed = clampf(_speed, 0.0, speed)
	speed = _speed
	decel = _decel
	
func _process(delta):
	var s = speed*10
	source.volume_db = linear_to_db(clamp(s,0,1))
	s -= 1
	source.pitch_scale = clamp(s, 1, 3)
	if (speed > 0): speed -= decel * delta
