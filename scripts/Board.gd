class_name Board
var subdiv: int = 4
var percentMined: float = 10
var triangles: Array
var vertices: PackedVector3Array
var boardGenerated: bool = false
var mines: int = 0
var nonMines: int = 0
var minesHit: int = 0
var mined: Dictionary
var numbered: Dictionary
var pointTriangleNeighbors: Array
var pointPointNeighbors: Array
var pointVectors: Array
var pointPositions: PackedVector3Array
var colors: PackedColorArray
var uvs: PackedVector2Array
var tris: PackedInt32Array
var colorsChanged: bool = false
var previousHit
var won: bool = false

static var leftSidePointIndex=[0, 1, 3, 6, 10, 15, 21, 28, 36, 45, 55, 66, 78, 91, 105, 120, 136, 153, 171, 190, 210]
static var rightSidePointIndex=[ 0, 2, 5, 9, 14, 20, 27, 35, 44, 54, 65, 77, 90, 104, 119, 135, 152, 170, 189, 209, 230 ]

var gm: Node3D
var gold: float = (1 + sqrt(5)) / 2

# Called when the node enters the scene tree for the first time.
func _ready():
	mines = 0;
	nonMines = 0;
	minesHit = 0;
	won = false;
	mined.clear()
	numbered.clear()
	build_board()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if colorsChanged:
		var arrays = []
		arrays.resize(ArrayMesh.ARRAY_MAX);
		arrays[ArrayMesh.ARRAY_COLOR] = colors;
		arrays[ArrayMesh.ARRAY_VERTEX] = vertices;
		arrays[ArrayMesh.ARRAY_TEX_UV] = uvs;
		arrays[ArrayMesh.ARRAY_INDEX] = tris;
		gm.update_mainMesh();
		gm.mainMesh.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays);
		colorsChanged=false

func build_board():
	triangles.clear()
	var verts := [Vector3(-1, gold , 0).normalized(),
		Vector3(1 , gold , 0).normalized(),
		Vector3(-1, -gold, 0).normalized(),
		Vector3(1 , -gold, 0).normalized(),
		Vector3(0, -1, gold ).normalized(),
		Vector3(0, 1 , gold ).normalized(),
		Vector3(0, -1, -gold).normalized(),
		Vector3(0, 1 , -gold).normalized(),
		Vector3(gold , 0, -1).normalized(),
		Vector3(gold , 0, 1 ).normalized(),
		Vector3(-gold, 0, -1).normalized(),
		Vector3(-gold, 0, 1 ).normalized()]
	var faces := [0, 11, 5,
		0, 5, 1,
		0, 1, 7,
		0, 7, 10,
		0, 10, 11,
		1, 5, 9,
		5, 11, 4,
		11, 10, 2,
		10, 7, 6,
		7, 1, 8, #9
		9,3,  4,
		4,3,  2,
		2,3,  6,
		6,3,  8,
		8,3,  9, #14
		9,4,  5,
		4,2,  11,
		2,6,  10,
		6,8,  7, #18
		8,9,  1]
	
	var icoFaces = []
	icoFaces.resize(20)
	var pointsPerCore = 1
	#for (int i = 0; i < subdiv; ++i) pointsPerCore += i + 2;
	for i in range(0, subdiv):
		pointsPerCore += i + 2
	var cornerNeighbors = []
	cornerNeighbors.resize(12)
	for i in range(0,12):
		cornerNeighbors[i] = []
	var lineNeighborWaiting = {}
	var totalPointCount = 0
	for i in range(0,20):
		#create icoface
		var facesIndex = i*3
		var face = IcoFace.create(pointsPerCore)
		face.count = i
		icoFaces[i]=face
		for j in range(0,3):
			var offsetIndex = facesIndex + j
			#match to corners
			var cornerIndex = faces[offsetIndex]
			face.corners[j] = cornerIndex
			face.cornerNeighbors[j] = cornerNeighbors[cornerIndex]
			face.cornerNeighbors[j].append(face)
			#line neighbor handling
			var line = Vector2i(faces[offsetIndex], faces[facesIndex+((j+1)%3)])
			face.lines[j] = line
			var neighborFound = false
			var neighbor = null
			neighbor = lineNeighborWaiting.get(line)
			if neighbor != null:
				neighborFound = true
				lineNeighborWaiting.erase(line)
				face.AssignLineNeighbor(false, neighbor, j)
			neighbor = lineNeighborWaiting.get(Vector2i(line.y, line.x))
			if neighbor != null:
				neighborFound = true
				lineNeighborWaiting.erase(Vector2i(line.y, line.x))
				face.AssignLineNeighbor(true,neighbor,j)
			if !neighborFound:
				lineNeighborWaiting[line] = face
		#populate points
		for j in range(0,3):
			#corners
			if (cornerNeighbors[face.corners[j]].size() == 5 && cornerNeighbors[face.corners[j]][0].GetCornerValue(face.corners[j], subdiv) == -1):
				for neighbor in cornerNeighbors[face.corners[j]]:
					neighbor.SetCornerValue(face.corners[j], subdiv, totalPointCount)
				totalPointCount+=1
			#lines
			if (subdiv > 1):
				if (face.lineNeighbors[j]==null):
					continue
				var neighborPoints = []
				neighborPoints.resize(subdiv-1)
				match j:
					0:
						if face.points[1] != -1: break
						for k in range(1,subdiv):
							face.points[leftSidePointIndex[k]] = totalPointCount
							neighborPoints[k-1]=totalPointCount
							totalPointCount+=1
					1:
						if face.points[face.points.size()-2] != -1: break
						for k in range(1,subdiv):
							face.points[pointsPerCore-1-k] = totalPointCount
							neighborPoints[k-1] = totalPointCount
							totalPointCount+=1
					2:
						if face.points[2] != -1:break
						for k in range(1,subdiv):
							face.points[rightSidePointIndex[k]] = totalPointCount
							neighborPoints[k-1] = totalPointCount
							totalPointCount+=1
				face.lineNeighbors[j].SetLinePoints(face.lines[j], face.lineNeighborFlip[j], neighborPoints,self)
		#interior
		for k in range (2, subdiv):
			for l in range(leftSidePointIndex[k]+1, rightSidePointIndex[k]):
				face.points[l] = totalPointCount
				totalPointCount +=1
	#set up neighbor lists
	pointTriangleNeighbors = []
	pointTriangleNeighbors.resize(totalPointCount)
	pointPointNeighbors = []
	pointPointNeighbors.resize(totalPointCount)
	pointVectors = []
	pointVectors.resize(totalPointCount)
	pointPositions = []
	pointPositions.resize(totalPointCount)
	for i in range(0,totalPointCount):
		pointTriangleNeighbors[i] = {}
		pointPointNeighbors[i] = {}
		pointVectors[i] = {}
	var vertexCount = 1
	for i in range(1,subdiv):
		vertexCount += 1 + (i*2)
	vertexCount *= 60
	vertices = []
	vertices.resize(vertexCount)
	for face in icoFaces:
		var pointsAC = GetGeodesicPoints(subdiv, verts[face.corners[1]], verts[face.corners[0]])
		var pointsAB = GetGeodesicPoints(subdiv,verts[face.corners[2]], verts[face.corners[0]])
		var vectors = []
		vectors.resize(face.points.size())
		pointPositions[face.points[0]] = verts[face.corners[0]]
		vectors[0] = verts[face.corners[0]]
		for i in range(1,subdiv+1):
			var geodesicPoints = GetGeodesicPoints(i, pointsAB[i], pointsAC[i])
			var ran = range(leftSidePointIndex[i], rightSidePointIndex[i])
			ran.append(rightSidePointIndex[i])
			for j in ran:
				vectors[j] = geodesicPoints[j-leftSidePointIndex[i]]
				pointPositions[face.points[j]] = vectors[j]
		var smallest = 9999
		for i in range (0,subdiv):
			var top = leftSidePointIndex[i]
			var bottom = leftSidePointIndex[i+1]
			var curTri = 0
			while curTri < 1 + (i * 2):
				var tri = Triangle.create()
				var indices = []
				indices.resize(3)
				if curTri % 2 == 0:
					indices[0] = bottom
					indices[2] = top
					bottom+=1
					indices[1] = bottom
				else:
					indices[0]=top
					top+=1
					indices[2]=top
					indices[1]=bottom
				if face.count < 10:
					var tmp = indices[0]
					indices[0] = indices[1]
					indices[1] = tmp
				curTri +=1
				var triVertexStart = triangles.size()*3
				tri.vertIndices = []
				tri.vertIndices.resize(3)
				tri.sharedIndices = []
				tri.sharedIndices.resize(3)
				triangles.append(tri)
				var mid = Vector3.ZERO
				for k in range(0,3):
					#assemble triangle information
					tri.vertIndices[k] = triVertexStart + k
					var chose = vectors[indices[k]]
					vertices[triVertexStart + k] = chose
					mid += vectors[indices[k]]
					var point = face.points[indices[k]]
					tri.sharedIndices[k] = point
					#add triangle to neighbor set
					pointTriangleNeighbors[point][tri] = null
					pointVectors[point][tri.vertIndices[k]] = null
				#handle icon size
				mid /= 3
				var dir = vectors[indices[2]]-mid
				var dist = dir.length() /2
				if smallest > dist: smallest = dist
				pointPointNeighbors[face.points[indices[0]]][face.points[indices[1]]]=null
				pointPointNeighbors[face.points[indices[0]]][face.points[indices[2]]]=null
				pointPointNeighbors[face.points[indices[1]]][face.points[indices[0]]]=null
				pointPointNeighbors[face.points[indices[1]]][face.points[indices[2]]]=null
				pointPointNeighbors[face.points[indices[2]]][face.points[indices[0]]]=null
				pointPointNeighbors[face.points[indices[2]]][face.points[indices[1]]]=null
		gm.iconSize = smallest
		#setup triangle neighbor sets
	for tri in triangles:
		for i in range(0,3):
			for neighbor in pointTriangleNeighbors[tri.sharedIndices[i]]:
				tri.neighbors[neighbor] = null
		tri.neighbors.erase(tri)
	
func BuildBoardVisuals():
	tris= []
	tris.resize(vertices.size())
	colors= []
	colors.resize(vertices.size())
	uvs= []
	uvs.resize(vertices.size())
	gm.glowMesh.colors.resize(vertices.size())
	var uvForEmpty = [Vector2(0,0),Vector2(0,1),Vector2(1,1)]
	for t in triangles:
		for i in t.vertIndices:
			tris[i] = i
			uvs[i] = uvForEmpty[i%3]
			if t.reveal:
				if t.mine: colors[i] = Color.RED
				else: colors[i] = VisualTheme.instance.GetClearedColor(vertices[i])
			else:
				colors[i] = VisualTheme.instance.GetBaseColor(vertices[i])
			gm.glowMesh.colors[i] = Color(1,1,1,0)
	#build main mesh
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_INDEX] = tris
	arrays[Mesh.ARRAY_COLOR] = colors
	gm.mainMesh.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	gm.glowMesh.Setup(vertices, tris)
	BuildIconBoard()
	
func BuildIconBoard():
	var itris:PackedInt32Array =[]
	itris.resize(triangles.size()*6)
	for i in range(0,itris.size()):
		itris[i]=i
	var vecs:PackedVector3Array= []
	vecs.resize(itris.size())
	for i in range(0,triangles.size()):
		var squ = triangles[i].GetSquareInTriangle(gm)
		for j in range(0,6):
			vecs[i*6+j] = squ[Triangle.squareTriangleOrder[j]]
			triangles[i].iconTriIndex[j] = i*6+j
	gm.isphere.arr = []
	gm.isphere.arr.resize(Mesh.ARRAY_MAX)
	gm.isphere.arr[Mesh.ARRAY_INDEX] = itris
	gm.isphere.arr[Mesh.ARRAY_VERTEX] = vecs
	gm.isphere.Init()

func LoadPreset():
	ResetBoard()
	boardGenerated = true
	mines = gm.preset.size()
	nonMines = triangles.size() - mines
	for i in gm.preset:
		var tri = triangles[i/3]
		mined[i/3]=null
		for t in tri.neighbors:
			numbered[t.vertIndices[0]/3] = null
			t.mineCount +=1
		tri.mine = true

func GetGeodesicPoints(amount,a,b):
	var ret = []
	var ran = range(0,amount)
	ran.append(amount)
	for i in ran:
		var axis = b.cross(a).normalized()
		var angle = acos(b.dot(a)) * (float(i)/amount)
		ret.append(Quaternion(axis, angle)*b)
	return ret

func LoadSave():
	PutMinesOnBoard(SaveManager.saveData.firstSelected)
	var lastMove = SaveManager.saveData.selected.size()-1
	for i in range(0,lastMove):
		SelectTriangle_List(SaveManager.saveData.selectArr[i], SaveManager.saveData.selected[i], true)
		SaveManager.saveData.flagActs[i].Load(gm)
	SelectTriangle_List(SaveManager.saveData.selectArr[lastMove], SaveManager.saveData.selected[lastMove], true)
	SaveManager.saveData.flagActs[lastMove].LoadPending(gm)
	for i in SaveManager.saveData.flagged:
		triangles[i].UpdateVisuals(gm)
	mines = SaveManager.saveData.mines
	nonMines = SaveManager.saveData.nonMines
	GameManager.loading = false

func GenerateNewBoard(triangleHit):
	var mineAmt = PutMinesOnBoard(triangleHit)
	mines -= mineAmt
	nonMines -= mines
	SaveManager.saveData.firstSelected = triangleHit
	SaveManager.saveData.mines = mines
	SaveManager.saveData.size = subdiv

func ResetBoard():
	mines = 0
	minesHit = 0
	nonMines = 0
	won = false
	mined.clear()
	numbered.clear()
	boardGenerated = false
	for t in triangles:
		t.mineCount = 0
		t.mine = false
		t.reveal = false
		t.flagged = false
		t.ChangeIcon(2,4,gm)
		for i in range(0,3):
			colors[t.vertIndices[i]] = VisualTheme.instance.GetBaseColor(vertices[t.vertIndices[i]])
	colorsChanged = true
	
func Flag(selected):
	if (!boardGenerated): return
	var t = triangles[selected]
	if (t.reveal): return
	t.flagged = !t.flagged
	if (t.flagged):
		mines-=1
		t.ChangeIcon(1,4, gm)
	else:
		mines+=1
		t.ChangeIcon(2,4, gm)
	SaveManager.saveData.mines = mines
	FlagAction.currentFlagAct.Change(gm,selected)

func SelectTriangle(triangleHit):
	var lst = [triangleHit]
	SelectTriangle_List(lst, triangleHit)
	
func SelectTriangle_List(indexArr, selected, loading = false):
	var index = selected
	previousHit = triangles[index]
	var doneCheck = {}
	var toCheck = {}
	var revealed = {}
	var high = 0
	var waves = 0
	if (triangles[index].mine && !triangles[index].reveal && !triangles[index].flagged):
		triangles[index].reveal = true
		triangles[index].UpdateVisuals(gm)
		minesHit += 1
		if (!loading):
			mines-=1
			FlagAction.Start()
			SaveManager.saveData.mines = mines
			SaveManager.saveData.mineHit = true
			SaveManager.saveData.selectArr.append(indexArr)
			SaveManager.saveData.selected.append(index)
			gm.paused = true
			SaveManager.save_game()
			gm.lose()
	else:
		for i in indexArr:
			if (triangles[i].mineCount > high): high = triangles[i].mineCount
			toCheck[triangles[i]] = null
			doneCheck[triangles[i]]=null
	while toCheck.size() > 0:
		waves+=1
		var nextCheck = {}
		for t in toCheck:
			if t.reveal:
				revealed[t]=null
				continue
			t.reveal = true
			t.UpdateVisuals(gm)
			if (t.mineCount == 0):
				for n in t.neighbors:
					if !n.flagged && !doneCheck.has(n):
						if (n.mineCount > high): high = n.mineCount
						doneCheck[n]=null
						nextCheck[n]=null
			nonMines -= 1
		toCheck = nextCheck.duplicate()
	if !loading:
		GameManager.instance.glowMesh.Add(triangles[index], doneCheck.duplicate())
		for t in revealed: doneCheck.erase(t)
		if (doneCheck.size() > indexArr.size()): ChainClearText.instance.UpdateText(doneCheck.size())
		if doneCheck.size() > 0:
			RevealSound.Play(waves, high)
			if nonMines == 0:
				won = true
				gm.paused = true
				if (GameManager.gameMode != 2): SaveManager.save_game()
				gm.win()
			else:
				FlagAction.Start()
				SaveManager.saveData.nonMines = nonMines
				SaveManager.saveData.selectArr.append(indexArr)
				SaveManager.saveData.selected.append(index)
	
func PutMinesOnBoard(loc):
	boardGenerated = true
	var mineAmt = int(float(triangles.size())*(float(percentMined)/100))
	var triList = triangles.duplicate(true)
	mines = mineAmt
	nonMines = triList.size()
	triList.remove_at(loc)
	for t in triangles[loc].neighbors:
		triList.erase(t)
	while (mineAmt > 0 and triList.size() > 0):
		mineAmt-=1
		var count = triList.size()
		var select = gm.gameRNG.randi_range(0,count-1)
		var tri = triList[select]
		mined[tri.vertIndices[0]/3] = null
		triList.remove_at(select)
		for t in tri.neighbors:
			numbered[t.vertIndices[0]/3] = null
			t.mineCount+=1
		tri.mine = true
	for t in mined: numbered.erase(t)
	return mineAmt
