#Original Source: https://www.youtube.com/watch?v=vKrrxKS-lcA

class_name Trail3D extends MeshInstance3D

var _points = []
var _lifePoints = []

@export var _trailEnabled : bool = true

@export var _fromWidth : float = 0.5

@export var _motionDelta : float = 0.1
@export var _lifespan : float = 1

@export var _startColor : Color = Color(1,1,1,1)
@export var _endColor : Color = Color(1,1,1,0)

var _oldPos : Vector3
var _oldPosArr : Array[Vector3]
var camPos

func _ready():
	camPos = get_viewport().get_camera_3d().position
	_oldPos = get_global_transform().origin
	mesh = ImmediateMesh.new()

func AppendPoint():
	_points.append(get_global_transform().origin)
	_oldPosArr.append(_oldPos)
	_lifePoints.append(0.0)

func RemovePoint(i):
	_points.remove_at(i)
	_lifePoints.remove_at(i)
	_oldPosArr.remove_at(i)

func _process(delta):
	var newPos = get_global_transform().origin
	if (_oldPos - newPos).length() > _motionDelta and _trailEnabled:
		AppendPoint()
		_oldPos = newPos
	var p = 0
	var max_points = _points.size()
	while p < max_points:
		_lifePoints[p] += delta
		if _lifePoints[p] > _lifespan:
			RemovePoint(p)
			p-=1
			if (p < 0):p=0
		max_points = _points.size()
		p += 1
	mesh.clear_surfaces()
	if _points.size() < 2: return
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	var size = _points.size()
	for i in range(_points.size()):
		AddVertex(_points[i], _oldPosArr[i], size, i)
	AddVertex(newPos, _points[_points.size()-1], size, size)
	mesh.surface_end()

func AddVertex(point, oldPos, pointsSize, i):
	var t = float(i) / (pointsSize)
	var currColor = _startColor.lerp(_endColor, 1-t)
	var camDir = camPos - point
	var oldDir = point - oldPos
	var widthDir = camDir.cross(oldDir).normalized()
	var currWidth = (widthDir*_fromWidth) * (t)
	var lpoint = to_local(point)
	mesh.surface_set_color(currColor)
	mesh.surface_set_uv(Vector2.ZERO)
	mesh.surface_add_vertex(lpoint+currWidth)
	mesh.surface_set_color(currColor)
	mesh.surface_set_uv(Vector2.ONE)
	mesh.surface_add_vertex(lpoint-currWidth)
