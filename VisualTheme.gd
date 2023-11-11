extends Node
class_name VisualTheme

@export var numberColors : Array[Color]
@export var firework : PackedScene

var timeToExplodeAll = 3.0
var timeSinceLastExplosion = -1.0
var timeBetweenExplosions = 0.0

static var explosions : Array
static var inUse : Array

static var instance : VisualTheme
static var pool = []

func _ready():
	instance = self
	timeToExplodeAll = 3 #timeToExplodeAll = sound.clip.length * ((int)(timeToExplodeAll / sound.clip.length));

func Reset():
	#return in use objects to pool
	#stop explosions
	timeSinceLastExplosion = -1
	explosions.clear()

func StartExplosion():
	print("explosion begin")
	var mined = []
	for i in range(0, GameManager.instance.board.numbered.size()):
		var num = GameManager.instance.board.numbered.keys()[i]
		print(GameManager.instance.board.triangles[num].mineCount)
		mined.append(GameManager.instance.board.triangles[num])
	timeBetweenExplosions = (timeToExplodeAll / mined.size())/1000 #milliseconds
	while mined.size() > 0:
		var rando = randi() % mined.size()
		explosions.insert(0,mined[rando])
		mined.remove_at(rando)

func _process(delta):
	if (timeSinceLastExplosion < Time.get_ticks_msec() && explosions.size() > 0):
		print("explode")
		timeSinceLastExplosion = Time.get_ticks_msec() + timeBetweenExplosions
		Explode(explosions[explosions.size()-1])
		explosions.remove_at(explosions.size()-1)
	if (explosions.size() == 0 && inUse.size() == 0):
		#sound.loop = false;
		pass

func Explode(exp):
	var obj = GetExplosion()
	inUse.append(obj)
	obj.begin(numberColors[exp.mineCount], 
	(GameManager.instance.board.vertices[exp.vertIndices[0]] +
	GameManager.instance.board.vertices[exp.vertIndices[1]] +
	GameManager.instance.board.vertices[exp.vertIndices[2]]) /
	3.0)

func GetExplosion():
	if (pool.size() == 0):
		var n = firework.instantiate()
		add_child(n)
		n.hide()
		n.set_process(false)
		n.home = self
		return n
	var ret = pool[pool.size()-1]
	pool.remove_at(pool.size()-1)
	return ret

func ReturnExplosion(ret):
	inUse.erase(ret)
	pool.insert(0,ret)
