extends MeshInstance3D

var colors : PackedColorArray
var array = []

var glowSpeed = 3.0
var timeBetweenWaves = .1*1000
var startTransparency = .66

var glows = {}
var toRemove = {}

var needsUpdating = false

func Setup(vertices, tris):
	array.resize(Mesh.ARRAY_MAX)
	array[Mesh.ARRAY_VERTEX] = vertices
	array[Mesh.ARRAY_COLOR] = colors
	array[Mesh.ARRAY_INDEX] = tris
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)

func Add(orig, valid):
	for t in valid.keys():
		var color = VisualTheme.instance.numberColors[t.mineCount] if (t.reveal and !t.mine) else Color.WHITE
		colors[t.vertIndices[0]] = color
		colors[t.vertIndices[1]] = color
		colors[t.vertIndices[2]] = color
	var glow = Glow.new()
	glow.valid = valid.duplicate()
	glow.lastChange = Time.get_ticks_msec() + timeBetweenWaves
	for i in orig.sharedIndices:
		glow.current[i]=null
		for t in GameManager.instance.board.pointTriangleNeighbors[i]:
			if (!valid.has(t)): continue
			for v in t.vertIndices: glow.glowing[v] = null
	glows[glow] = null
	array[Mesh.ARRAY_COLOR] = colors
	mesh.clear_surfaces()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)

func Reset():
	for c in colors: c = Color(1,1,1,0)
	glows.clear()
	array[Mesh.ARRAY_COLOR] = colors
	mesh.clear_surfaces()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)

func _process(delta):
	for g in toRemove: glows.erase(g)
	for g in glows: g.Update(delta)
	if needsUpdating:
		needsUpdating = false
		array[Mesh.ARRAY_COLOR] = colors
		mesh.clear_surfaces()
		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
