extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var yRot = Input.get_axis("ui_left", "ui_right")*delta
	var xRot = Input.get_axis("ui_up", "ui_down")*delta
	var cam = get_viewport().get_camera_3d()
	rotate(cam.get_camera_transform().basis.x, xRot)
	rotate(cam.get_camera_transform().basis.y, yRot)
