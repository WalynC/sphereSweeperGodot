class_name Glow

var previous = {}
var current = {}
var glowing = {}
var valid = {}
var lastChange = 0.0

func Update(delta):
	var clear = {}
	for g in glowing:
		var val = GameManager.instance.glowMesh.colors[g].a - delta * GameManager.instance.glowMesh.glowSpeed
		GameManager.instance.glowMesh.colors[g].a = val
		if val <= 0: clear[g] = null
	if lastChange <= Time.get_ticks_msec() && current.size() > 0:
		BeginNextWave()
		lastChange = Time.get_ticks_msec() + GameManager.instance.glowMesh.timeBetweenWaves
	for c in clear: glowing.erase(c)
	if glowing.size() == 0: GameManager.instance.glowMesh.toRemove[self] = null
	GameManager.instance.glowMesh.needsUpdating = true

func BeginNextWave():
	var next = {}
	var high = 0
	for c in current:
		for t in GameManager.instance.board.pointTriangleNeighbors[c]:
			if !valid.has(t): continue
			if high < t.mineCount: high = t.mineCount
			for n in t.sharedIndices: next[n] = null
	for u in previous: next.erase(u)
	previous = current
	for u in previous: next.erase(u)
	current = next
	for n in next:
		for t in GameManager.instance.board.pointTriangleNeighbors[n]:
			if !valid.has(t): continue
			for v in GameManager.instance.board.pointVectors[n]: glowing[v]=null
