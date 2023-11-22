var uvs: PackedVector2Array = []
var changed = false
var arr = []
var gm

func Init():
	uvs.resize(gm.board.triangles.size()*6)
	arr[Mesh.ARRAY_TEX_UV] = uvs
	gm.iconMesh.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)

func Change(index, value):
	if uvs[index] == value: 
		pass
	uvs[index] = value
	changed = true

func _process(_delta):
	if (changed):
		gm.iconMesh.mesh.clear_surfaces()
		arr[Mesh.ARRAY_TEX_UV] = uvs
		gm.iconMesh.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
		changed = false

