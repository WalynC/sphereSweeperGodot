extends Node3D

@export var star:GPUParticles3D
@export var explosion:GPUParticles3D
@export var trail:MeshInstance3D
@export var trailOffset:Node3D

var timePassed = 0
var home
var used = false

func setParticleScale():
	var _scale = lerpf(.5, 1.5,float(GameManager.instance.board.subdiv)/20.0)
	setScales(star, _scale)
	setScales(explosion, _scale)

func setScales(particle, _scale):
	#particle.process_material.scale_min /= scale
	#particle.process_material.scale_max /= scale
	particle.draw_pass_1.size /= _scale

func reset_values():
	if (used):
		restart()
		star.restart()
		explosion.restart()
	show()
	set_process(true)
	timePassed = 0
	#speed_scale = 1

func restart():
	pass

func begin(color, direction):
	used = true
	
	transform.origin = direction
	transform.basis.y = direction
	orthonormalize()
	#draw_pass_1.surface_get_material(0).albedo_color = color
	#process_material.direction = direction
	#emit_particle(transform, Vector3.ZERO, Color.WHITE, Color.WHITE, 0)
	star.process_material.direction = Vector3.UP
	star.draw_pass_1.surface_get_material(0).albedo_color = color
	#star.emit_particle(transform, Vector3.ZERO, Color.WHITE, Color.WHITE, 0)
	explosion.draw_pass_1.surface_get_material(0).albedo_color = color
	#explosion.process_material.color_ramp.gradient.set_color(1, Color(color.r, color.g, color.b, 0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#trail.look_at(get_viewport().get_camera_3d().position)
	timePassed += delta
	if (timePassed > 2):
		explosion.emitting = true
		star.emitting = false
		#speed_scale = 0
	if (timePassed > 3):
		explosion.emitting = false
		hide()
		set_process(false)
		#home.ReturnExplosion(self)
