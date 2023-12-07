extends Node
class_name StarLoader

@export var star : PackedScene
var objects = []

func Generate():
	for i in range(250):
		var o = star.instantiate()
		objects.append(o)
		GameManager.instance.worldPivot.add_child(o)
		o.position = GetRandomPointOnUnitSphereSurface(GameManager.visRNG) * GameManager.visRNG.randf_range(2.5, 10.0)

func GetRandomPointOnUnitSphereSurface(rng:RandomNumberGenerator):
	#https://math.stackexchange.com/questions/1585975/how-to-generate-random-points-on-a-sphere/1586185#1586185
	var u1 = rng.randf_range(0,1)
	var u2 = rng.randf_range(0,1)
	var phi = acos(2*u1-1)-(PI/2)
	var lambda = 2*PI*u2
	return Vector3(cos(phi)*cos(lambda), cos(phi)*sin(lambda), sin(phi))

func Cleanup():
	while objects.size() > 0:
		var o = objects[0]
		o.queue_free()
		objects.remove_at(0)
