extends Node
class_name SelectIndicator

@export var inner : MeshInstance3D
@export var outer : MeshInstance3D
var innerArrays
var outerArrays

func _ready():
	innerArrays = []
	innerArrays.resize(Mesh.ARRAY_MAX)
	outerArrays = []
	outerArrays.resize(Mesh.ARRAY_MAX)
	var uvs : PackedVector2Array
	uvs.resize(36)
	for i in range(0,6):
		uvs[0 + (6 * i)] = Vector2(0, 1);
		uvs[1 + (6 * i)] = Vector2(1, 1);
		uvs[2 + (6 * i)] = Vector2(0, 0);
		uvs[3 + (6 * i)] = Vector2(0, 0);
		uvs[4 + (6 * i)] = Vector2(1, 1);
		uvs[5 + (6 * i)] = Vector2(1, 0)
	var tris : PackedInt32Array
	tris.resize(36)
	for i in range(0,36): tris[i]=i
	innerArrays[Mesh.ARRAY_TEX_UV] = uvs
	innerArrays[Mesh.ARRAY_INDEX] = tris

func Indicate(t):
	var closeVerts = [GameManager.instance.board.vertices[t.vertIndices[0]],GameManager.instance.board.vertices[t.vertIndices[1]],GameManager.instance.board.vertices[t.vertIndices[2]]]
	var upVerts = [closeVerts[0]*1.1, closeVerts[1]*1.1, closeVerts[2]*1.1 ]
	var mid = closeVerts[0]+closeVerts[1]+closeVerts[2]
	mid/=3
	var inVerts = [((closeVerts[0]+mid)/2)*1.05,((closeVerts[1]+mid)/2)*1.05,((closeVerts[2]+mid)/2)*1.05]
	var verts : PackedVector3Array
	verts =[closeVerts[0], closeVerts[1], upVerts[0],
	upVerts[0], closeVerts[1], upVerts[1],
	closeVerts[1], closeVerts[2], upVerts[1],
	upVerts[1], closeVerts[2], upVerts[2],
	closeVerts[2], closeVerts[0], upVerts[2],
	upVerts[2], closeVerts[0], upVerts[0],
	closeVerts[0], closeVerts[1], inVerts[0],
	inVerts[0], closeVerts[1], inVerts[1],
	closeVerts[1], closeVerts[2], inVerts[1],
	inVerts[1], closeVerts[2], inVerts[2],
	closeVerts[2], closeVerts[0], inVerts[2],
	inVerts[2], closeVerts[0], inVerts[0]]
	innerArrays[Mesh.ARRAY_VERTEX] = verts
	inner.mesh.clear_surfaces()
	inner.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, innerArrays)
	inner.show()

func IndicateNeighbors(t):
	Indicate(t)
	var orig = {t.sharedIndices[0]:null,t.sharedIndices[1]:null,t.sharedIndices[2]:null }
	var endVerts = []
	var endUVs = []
	for n in t.neighbors:
		var verts = []
		var mid = Vector3.ZERO
		for i in range (0,3):
			if !orig.has(n.sharedIndices[i]): verts.append(GameManager.instance.board.vertices[n.vertIndices[i]])
			else: mid = GameManager.instance.board.vertices[n.vertIndices[i]]
		if verts.size() == 2:
			var farVerts = [verts[0]*1.1, verts[1]*1.1]
			var midVerts = [((verts[0]+mid)/2)*1.05,((verts[1]+mid)/2)*1.05]
			endVerts.append_array([verts[0], verts[1], farVerts[0],
			farVerts[0], verts[1], farVerts[1],
			verts[0], verts[1], midVerts[0],
			midVerts[0], verts[1], midVerts[1]])
			var uvs = []
			uvs.resize(12)
			for i in range(0,2):
				uvs[0 + (6 * i)] = Vector2(0, 1)
				uvs[1 + (6 * i)] = Vector2(1, 1)
				uvs[2 + (6 * i)] = Vector2(0, 0)
				uvs[3 + (6 * i)] = Vector2(0, 0)
				uvs[4 + (6 * i)] = Vector2(1, 1)
				uvs[5 + (6 * i)] = Vector2(1, 0)
			endUVs.append_array(uvs)
		else:
			var verticesSet = []
			mid = Vector3.ZERO
			for i in range(0,3):
				verticesSet.append(GameManager.instance.board.vertices[n.vertIndices[i]])
				if (!orig.has(n.sharedIndices[i])):
					mid = verticesSet[verticesSet.size()-1]
					verticesSet.remove_at(verticesSet.size()-1)
			endVerts.append_array([mid, ((verticesSet[0]+mid)/2)*1.05, ((verticesSet[1]+mid)/2)*1.05])
			endUVs.append_array([Vector2(0,1), Vector2.ZERO, Vector2(1,0)])
	var tris : PackedInt32Array
	tris.resize(endVerts.size())
	for i in range(0,tris.size()): tris[i]=i
	var packedverts : PackedVector3Array
	packedverts = endVerts
	var packeduvs : PackedVector3Array
	packeduvs = endUVs
	outerArrays[Mesh.ARRAY_TEX_UV] = packeduvs
	outerArrays[Mesh.ARRAY_VERTEX] = packedverts
	outerArrays[Mesh.ARRAY_INDEX] = tris
	outer.mesh.clear_surfaces()
	outer.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, outerArrays)
	outer.show()
	

func EndIndicate():
	inner.hide()
	outer.hide()
