extends SelectIndicator
class_name TutorialIndicator

static var tutorialInst

func _ready():
	tutorialInst = self
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
