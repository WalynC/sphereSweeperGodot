extends Node


@export var firework : PackedScene
var explosions : Array
var inUse : Array

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

func StartExplosion():
	Explode(GameManager.instance.board.previousHit)
	var mined = []
	for i in range(0, GameManager.instance.board.mined.size()):
		var num = GameManager.instance.board.mined.keys()[i]
		mined.append(GameManager.instance.board.triangles[num])
	for i in range(0, 20):
		if mined.size() == 0: break
		var rando = GameManager.visRNG.randi() % mined.size()
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
		GameManager.instance.worldPivot.add_child(n)
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
