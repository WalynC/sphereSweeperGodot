extends Node
class_name SelectIndicator

static var inst
@export var inner : MeshInstance3D
@export var outer : MeshInstance3D
var innerArrays

func _ready():
	inst = self
	innerArrays = []
	innerArrays.resize(Mesh.ARRAY_MAX)
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

var debug = false
func _process(delta):
	if (!debug):
		Indicate(GameManager.instance.board.triangles[0])
		debug = true

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
	
