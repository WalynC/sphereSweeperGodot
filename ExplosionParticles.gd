extends GPUParticles3D

var timePassed = 0
var home
var used = false

func reset_values():
	if (used):
		restart()
	timePassed = 0
	emitting = true
	show()
	set_process(true)

func begin(dir):
	used = true
	transform.origin = dir
	process_material.direction = dir
	process_material.gravity = dir*-.98

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timePassed += delta
	if (timePassed > 4):
		hide()
		set_process(false)
		home.ReturnExplosion(self)
