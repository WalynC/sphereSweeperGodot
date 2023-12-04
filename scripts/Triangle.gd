class_name Triangle

var vertIndices
var sharedIndices
var mine = false
var reveal = false
var flagged = false
var mineCount = 0
var iconTriIndex = []

const squareTriangleOrder := [1,0,3,2, 3,0]
var neighbors
const textureOffset = [Vector2(float(1)/3,0),Vector2(0,0),Vector2(float(1)/3,float(1)/5), Vector2(0,float(1)/5)]

static func create():
	var inst = Triangle.new()
	inst.iconTriIndex.resize(6)
	inst.neighbors = {}
	return inst

func GetSquareInTriangle(gm):
	var ret = []
	ret.resize(4)
	var a = gm.board.vertices[vertIndices[0]]
	var b = gm.board.vertices[vertIndices[1]]
	var c = gm.board.vertices[vertIndices[2]]
	var mid = a+b+c
	mid /=3
	var norm = (b-a).normalized().cross((c-a).normalized())
	var dir = norm.cross((a+c)/2).normalized()
	var cross = dir.cross(norm).normalized()
	ret[3] = mid + (dir + cross).normalized() * gm.iconSize;
	ret[1] = mid + (dir - cross).normalized() * gm.iconSize;
	ret[2] = mid + (-dir + cross).normalized() * gm.iconSize;
	ret[0] = mid + (-dir - cross).normalized() * gm.iconSize;
	return ret;

func UpdateVisuals(gm):
	if reveal:
		if mine:
			for i in range(0,3):
				gm.board.colors[vertIndices[i]] = Color.RED
			ChangeIcon(0,4,gm)
		else:
			for i in range(0,3):
				gm.board.colors[vertIndices[i]] = VisualTheme.instance.GetClearedColor(vertIndices[i])
			var count = mineCount
			if (count > 0):
				var y = 4
				var yCounter = count
				while yCounter > 0:
					y-=1
					yCounter -=3
				var x = (count-1)%3
				ChangeIcon(x,y,gm)
			else:
				ChangeIcon(2,4,gm)
		gm.board.colorsChanged = true
	elif flagged:
		ChangeIcon(1,4,gm)

func ChangeIcon(x,y,gm):
	var pos = Vector2(float(x)/3, float(4-y)/5)
	for i in range(0,6):
		gm.isphere.Change(iconTriIndex[i], pos+textureOffset[squareTriangleOrder[i]])
