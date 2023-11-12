extends Node
class_name FireworksEffect

@export var firework : PackedScene

var timeToExplodeAll = 10.0
var timeSinceLastExplosion = -1.0
var timeBetweenExplosions = 0.0

static var explosions : Array
static var inUse : Array

static var pool = []

func _ready():
	timeToExplodeAll = 10 #timeToExplodeAll = sound.clip.length * ((int)(timeToExplodeAll / sound.clip.length));

func Reset():
	#return in use objects to pool
	var copy = inUse.duplicate()
	for i in range(0,copy.size()):
		copy[i].hide()
		copy[i].set_process(false)
		ReturnExplosion(copy[i])
	#stop explosions
	timeSinceLastExplosion = -1
	explosions.clear()

func StartExplosion():
	var mined = []
	for i in range(0, GameManager.instance.board.numbered.size()):
		var num = GameManager.instance.board.numbered.keys()[i]
		mined.append(GameManager.instance.board.triangles[num])
	timeBetweenExplosions = (timeToExplodeAll / float(mined.size())*1000) #milliseconds
	while mined.size() > 0:
		var rando = randi() % mined.size()
		explosions.insert(0,mined[rando])
		mined.remove_at(rando)

func _process(_delta):
	if (timeSinceLastExplosion < Time.get_ticks_msec() && explosions.size() > 0):
		timeSinceLastExplosion = Time.get_ticks_msec() + timeBetweenExplosions
		Explode(explosions[explosions.size()-1])
		explosions.remove_at(explosions.size()-1)
	if (explosions.size() == 0 && inUse.size() == 0):
		#sound.loop = false;
		pass

func Explode(explo):
	var obj = GetExplosion()
	inUse.append(obj)
	obj.begin(VisualTheme.instance.numberColors[explo.mineCount], 
	(GameManager.instance.board.vertices[explo.vertIndices[0]] +
	GameManager.instance.board.vertices[explo.vertIndices[1]] +
	GameManager.instance.board.vertices[explo.vertIndices[2]]) /
	3.0)

func GetExplosion():
	if (pool.size() == 0):
		var n = firework.instantiate()
		add_child(n)
		n.home = self
		n.reset_values()
		return n
	var ret = pool[pool.size()-1]
	pool.remove_at(pool.size()-1)
	ret.reset_values()
	return ret

func ReturnExplosion(ret):
	inUse.erase(ret)
	pool.insert(0,ret)
