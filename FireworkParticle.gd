extends GPUParticles3D

@export var star:GPUParticles3D
@export var explosion:GPUParticles3D

var timePassed = 0

func _ready():
	begin(Color(1,0,0), Vector3(0,1,-5))

func begin(color, direction):
	timePassed = 0
	speed_scale = 1
	draw_pass_1.surface_get_material(0).albedo_color = color
	process_material.direction = direction
	emit_particle(transform, Vector3.ZERO, Color.WHITE, Color.WHITE, 0)
	star.process_material.direction = direction
	star.draw_pass_1.surface_get_material(0).albedo_color = color
	star.emit_particle(transform, Vector3.ZERO, Color.WHITE, Color.WHITE, 0)
	explosion.process_material.color_ramp.gradient.set_color(0, color)
	explosion.process_material.color_ramp.gradient.set_color(1, Color(color.r, color.g, color.b, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timePassed += delta
	if (timePassed > 2):
		speed_scale = 0
	if (timePassed > 3):
		queue_free()
