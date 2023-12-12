extends Node
class_name WindSound

static var instance : WindSound
@export var source : AudioStreamPlayer
var speed = 0.0
var decel = 1.0
var maxVolume = 1.0

func _ready():
	instance = self

func Spin(_speed, _decel, clampSpeedToHighest = false):
	if (clampSpeedToHighest): _speed = clampf(_speed, 0.0, speed)
	speed = _speed
	decel = _decel
	maxVolume = 0.0
	
func _process(delta):
	maxVolume = move_toward(maxVolume, 1.0, 2*delta)
	source.volume_db = clamp(speed/decel, 0, maxVolume)
	source.pitch_scale = clamp(speed/(decel*2), 1, 3)
	if (speed > 0): speed -= decel * delta
