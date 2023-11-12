extends MeshInstance3D

var colors : PackedColorArray
var array = []

func Setup(vertices, tris):
	array.resize(Mesh.ARRAY_MAX)
	array[Mesh.ARRAY_VERTEX] = vertices
	array[Mesh.ARRAY_COLOR] = colors
	array[Mesh.ARRAY_INDEX] = tris
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)

func Highlight(t):
	colors[t.vertIndices[0]] = VisualTheme.instance.numberColors[t.mineCount]
	colors[t.vertIndices[1]] = VisualTheme.instance.numberColors[t.mineCount]
	colors[t.vertIndices[2]] = VisualTheme.instance.numberColors[t.mineCount]
	array[Mesh.ARRAY_COLOR] = colors
	mesh.clear_surfaces()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	print(colors)
