extends Node
class_name FireworksEffect

@export var firework : PackedScene
@export var sound : AudioStreamPlayer
@export var baseTrail : BaseMaterial3D

var timeToExplodeAll = 12.0
var timeSinceLastExplosion = -1.0
var timeBetweenExplosions = 0.0

var explosions : Array
var inUse : Array
var playSound = false

var pool = []

var trailMats = []
var initialized = false

func init():
	if (initialized): return
	initialized = true
	timeToExplodeAll = sound.stream.get_length() * int((timeToExplodeAll / sound.stream.get_length()) - 1) +3 
	trailMats.clear()
	for i in range(0,VisualTheme.instance.numberColors.size()):
		var trail = baseTrail.duplicate()
		trail.albedo_color = VisualTheme.instance.numberColors[i]
		trailMats.append(trail)

func Reset():
	#return in use objects to pool
	var copy = inUse.duplicate()
	for i in range(0,copy.size()):
		copy[i].hide()
		copy[i].set_process(false)
		ReturnExplosion(copy[i])
	#stop explosions
	timeSinceLastExplosion = -1
	sound.stop()
	explosions.clear()

func StartExplosion():
	init()
	var mined = []
	playSound = true
	for i in range(0, GameManager.instance.board.numbered.size()):
		var num = GameManager.instance.board.numbered.keys()[i]
		mined.append(GameManager.instance.board.triangles[num])
	timeBetweenExplosions = (timeToExplodeAll / float(mined.size())*1000) #milliseconds
	while mined.size() > 0:
		var rando = GameManager.visRNG.randi() % mined.size()
		explosions.insert(0,mined[rando])
		mined.remove_at(rando)

func _process(_delta):
	if (timeSinceLastExplosion < Time.get_ticks_msec() && explosions.size() > 0):
		timeSinceLastExplosion = Time.get_ticks_msec() + timeBetweenExplosions
		Explode(explosions[explosions.size()-1])
		explosions.remove_at(explosions.size()-1)
	if (explosions.size() == 0 && inUse.size() == 0):
		playSound = false
	if (playSound && !sound.playing):
		sound.play()

func Explode(explo):
	var obj = GetExplosion()
	inUse.append(obj)
	obj.begin(explo.mineCount, 
	(GameManager.instance.board.vertices[explo.vertIndices[0]] +
	GameManager.instance.board.vertices[explo.vertIndices[1]] +
	GameManager.instance.board.vertices[explo.vertIndices[2]]) /
	3.0, self)

func GetExplosion():
	if (pool.size() == 0):
		var n = firework.instantiate()
		GameManager.instance.worldPivot.add_child(n)
		n.home = self
		for i in range(0, n.trails.size()):
			n.trails[i].mesh = n.trails[i].mesh.duplicate()
		n.setParticleScale()
		n.reset_values()
		return n
	var ret = pool[pool.size()-1]
	pool.remove_at(pool.size()-1)
	ret.reset_values()
	return ret

func ReturnExplosion(ret):
	inUse.erase(ret)
	pool.insert(0,ret)
