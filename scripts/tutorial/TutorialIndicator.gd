extends SelectIndicator
class_name TutorialIndicator

var inUse : Array[MeshInstance3D]
var uvs : PackedVector2Array
var tris : PackedInt32Array

@export var indicatorObject : PackedScene

func _ready():
	uvs.resize(36)
	for i in range(0,6):
		uvs[0 + (6 * i)] = Vector2(0, 1);
		uvs[1 + (6 * i)] = Vector2(1, 1);
		uvs[2 + (6 * i)] = Vector2(0, 0);
		uvs[3 + (6 * i)] = Vector2(0, 0);
		uvs[4 + (6 * i)] = Vector2(1, 1);
		uvs[5 + (6 * i)] = Vector2(1, 0)
	tris.resize(36)
	for i in range(0,36): tris[i]=i

func Indicate(t):
	var object = indicatorObject.instantiate()
	self.add_child(object)
	var closeVerts = [GameManager.instance.board.vertices[t.vertIndices[0]]*1.001,GameManager.instance.board.vertices[t.vertIndices[1]]*1.001,GameManager.instance.board.vertices[t.vertIndices[2]]*1.001]
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
	#assemble mesh, including UVs/tris
	var meshArrays = []
	meshArrays.resize(Mesh.ARRAY_MAX)
	meshArrays[Mesh.ARRAY_VERTEX] = verts
	meshArrays[Mesh.ARRAY_TEX_UV] = uvs
	meshArrays[Mesh.ARRAY_INDEX] = tris
	object.mesh.clear_surfaces()
	object.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, meshArrays)
	inUse.push_back(object)

func EndIndicate():
	for i in inUse:
		i.queue_free()
	inUse.clear()
	inUse.resize(0)
	pass
