extends MeshInstance3D

var subdiv = 3
var vertices : PackedVector3Array

var gold: float = (1 + sqrt(5)) / 2
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

func Build():
	var pointsPerFace = 1
	var trisPerFace = 0
	for i in range(subdiv):
		pointsPerFace += i + 2
		trisPerFace += 1 + (i*2)
	var total = 0
	vertices.resize(trisPerFace*60)
	for i in range(0, faces.size(), 3):
		var pointsAC = GetGeodesicPoints(subdiv, verts[faces[i+1]], verts[faces[i]])
		var pointsAB = GetGeodesicPoints(subdiv,verts[faces[i+2]], verts[faces[i]])
		var vectors : Array[Vector3]
		vectors.resize(pointsPerFace)
		vectors[0] = verts[faces[i]]
		for k in range(1,subdiv+1):
			var geodesic = GetGeodesicPoints(k, pointsAB[k], pointsAC[k])
			for j in range(Board.leftSidePointIndex[k], Board.rightSidePointIndex[k]+1):
				vectors[j] = geodesic[j-Board.leftSidePointIndex[k]]
		for k in range(subdiv):
			var top = Board.leftSidePointIndex[k]
			var bottom = Board.leftSidePointIndex[k+1]
			var curTri = 0
			while curTri < 1 + (k * 2):
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
				if i < 30:
					var tmp = indices[0]
					indices[0] = indices[1]
					indices[1] = tmp
				curTri +=1
				vertices[total]=vectors[indices[0]]
				vertices[total+1]=vectors[indices[1]]
				vertices[total+2]=vectors[indices[2]]
				total+=3
	BuildBoardVisuals()

func BuildBoardVisuals():
	var tris : PackedInt32Array
	tris.resize(vertices.size())
	var colors : PackedColorArray
	colors.resize(vertices.size())
	var uvs : PackedVector2Array
	uvs.resize(vertices.size())
	var uvForEmpty = [Vector2(0,0),Vector2(0,1),Vector2(1,1)]
	for i in range(vertices.size()):
		tris[i] = i
		uvs[i] = uvForEmpty[i%3]
		colors[i] = VisualTheme.instance.GetBaseColor(vertices[i])
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_INDEX] = tris
	arrays[Mesh.ARRAY_COLOR] = colors
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	rotate(Vector3.UP, randf_range(-180, 180))
	rotate(Vector3.RIGHT, randf_range(-180, 180))
	rotate(Vector3.FORWARD, randf_range(-180, 180))

func GetGeodesicPoints(amount,a,b):
	var ret = []
	var ran = range(0,amount)
	ran.append(amount)
	for i in ran:
		var axis = b.cross(a).normalized()
		var angle = acos(b.dot(a)) * (float(i)/amount)
		ret.append(Quaternion(axis, angle)*b)
	return ret

func _process(delta):
	rotate(Vector3.UP, -.075*delta)
