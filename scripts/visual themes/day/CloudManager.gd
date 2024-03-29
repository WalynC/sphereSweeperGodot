extends Node

@export var clouds : Array[Node3D]
var rotDir : Array[Vector3]

func GenerateClouds():
	rotDir.resize(clouds.size())
	var time = SaveManager.saveData.visualTime if GameManager.loading else 0.0
	for i in range(0, clouds.size()):
		var speed = deg_to_rad(GameManager.visRNG.randf_range(0.5, 0.25) * (-1 if GameManager.visRNG.randi_range(0,1) == 0 else 1))
		rotDir[i] = Vector3.UP*speed
		clouds[i].reparent(GameManager.instance.worldPivot)
		clouds[i].position = Vector3.ZERO
		clouds[i].rotate_object_local(Vector3.UP, deg_to_rad(GameManager.visRNG.randf_range(-180, 180)))
		clouds[i].rotate_object_local(Vector3.RIGHT, deg_to_rad(GameManager.visRNG.randf_range(-180, 180)))
		clouds[i].rotate_object_local(Vector3.FORWARD, deg_to_rad(GameManager.visRNG.randf_range(-180, 180)))
		clouds[i].rotation *= Quaternion.from_euler(rotDir[i] * time)

func Cleanup():
	for i in range(clouds.size()):
		clouds[i].queue_free()

func _process(delta):
	if (GameManager.instance.paused): return
	for i in range(0, clouds.size()):
		clouds[i].rotation *= Quaternion.from_euler(rotDir[i] * delta)
