extends Node
class_name ExplosionEffect

@export var firework : PackedScene
var explosions : Array #spaces that need to be exploded
var inUse : Array
@export var explosionSound : AudioStreamPlayer
var explosionCount = 20

var pool = []

func Reset():
	#return in use objects to pool
	var copy = inUse.duplicate()
	for i in range(0,copy.size()):
		copy[i].hide()
		copy[i].set_process(false)
		ReturnExplosion(copy[i])
	#stop explosions
	explosions.clear()

func Cleanup():
	explosions.clear()
	for i in inUse:
		i.queue_free()
	for i in pool:
		i.queue_free()
	inUse.clear()
	pool.clear()

func StartExplosion():
	Explode(GameManager.instance.board.previousHit)
	var mined = []
	for i in range(0, GameManager.instance.board.mined.size()):
		var num = GameManager.instance.board.mined.keys()[i]
		mined.append(GameManager.instance.board.triangles[num])
	for i in range(0, explosionCount):
		if mined.size() == 0: break
		var rando = GameManager.visRNG.randi() % mined.size()
		Explode(mined[rando])
		mined.remove_at(rando)
	explosionSound.play()

func Explode(explo):
	var obj = GetExplosion()
	inUse.append(obj)
	var dir = ((GameManager.instance.board.vertices[explo.vertIndices[0]] +
	GameManager.instance.board.vertices[explo.vertIndices[1]] +
	GameManager.instance.board.vertices[explo.vertIndices[2]]) /
	3.0)
	obj.home = self
	obj.begin(dir)

func InstantiateExplosion():
	var n = firework.instantiate()
	GameManager.instance.worldPivot.add_child(n)
	n.home = self
	return n

func GetExplosion():
	if (pool.size() == 0):
		var n = InstantiateExplosion()
		n.reset_values()
		return n
	var ret = pool[pool.size()-1]
	pool.remove_at(pool.size()-1)
	ret.reset_values()
	return ret

func PreloadExplosions():
	while pool.size() + inUse.size()  < explosionCount:
		var n = InstantiateExplosion()
		pool.insert(0,n)

func ReturnExplosion(ret):
	inUse.erase(ret)
	pool.insert(0,ret)
