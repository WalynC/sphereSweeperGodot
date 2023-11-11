extends Node


@export var firework : PackedScene
static var explosions : Array
static var inUse : Array

static var pool = []

func Reset():
	#return in use objects to pool
	var copy = inUse.duplicate()
	for i in range(0,copy.size()):
		copy[i].hide()
		copy[i].set_process(false)
		ReturnExplosion(copy[i])
	#stop explosions
	explosions.clear()

func StartExplosion():
	Explode(GameManager.instance.board.previousHit)
	var mined = []
	for i in range(0, GameManager.instance.board.mined.size()):
		var num = GameManager.instance.board.mined.keys()[i]
		mined.append(GameManager.instance.board.triangles[num])
	for i in range(0, 20):
		if mined.size() == 0: break
		var rando = randi() % mined.size()
		Explode(mined[rando])
		mined.remove_at(rando)

func Explode(explo):
	var obj = GetExplosion()
	inUse.append(obj)
	var dir = ((GameManager.instance.board.vertices[explo.vertIndices[0]] +
	GameManager.instance.board.vertices[explo.vertIndices[1]] +
	GameManager.instance.board.vertices[explo.vertIndices[2]]) /
	3.0)
	obj.home = self
	obj.begin(dir)

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
