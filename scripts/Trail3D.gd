#Original Source: https://www.youtube.com/watch?v=vKrrxKS-lcA

class_name Trail3D extends MeshInstance3D

var _points = []
var _widths = []
var _lifePoints = []

@export var _trailEnabled : bool = true

@export var _fromWidth : float = 0.5
@export var _toWidth : float = 0.0
@export_range(0.5, 1.5) var _scaleAcceleration : float = 1.0

@export var _motionDelta : float = 0.1
@export var _lifespan : float = 1

@export var _startColor : Color = Color(1,1,1,1)
@export var _endColor : Color = Color(1,1,1,0)

var _oldPos : Vector3
var _oldPosArr : Array[Vector3]

func _ready():
	_oldPos = get_global_transform().origin
	mesh = ImmediateMesh.new()

func AppendPoint():
	_points.append(get_global_transform().origin)
	_widths.append([
		get_global_transform().basis.x * _fromWidth, 
		get_global_transform().basis.x * _fromWidth - get_global_transform().basis.x * _toWidth])
	_oldPosArr.append(_oldPos)
	_lifePoints.append(0.0)

func RemovePoint(i):
	_points.remove_at(i)
	_widths.remove_at(i)
	_lifePoints.remove_at(i)
	_oldPosArr.remove_at(i)

func _process(delta):
	if (_oldPos - get_global_transform().origin).length() > _motionDelta and _trailEnabled:
		AppendPoint()
		_oldPos = get_global_transform().origin
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
	for i in range(_points.size()):
		var t = float(i) / (_points.size() - 1.0)
		var currColor = _startColor.lerp(_endColor, 1-t)
		mesh.surface_set_color(currColor)
		var camPos = get_viewport().get_camera_3d().position
		var camDir = camPos - _points[i]
		var oldDir = _points[i] - _oldPosArr[i]
		var viewDir = camDir.cross(oldDir).normalized()
		var currWidth = (viewDir*_fromWidth) - pow(1-t, _scaleAcceleration) * (viewDir*_fromWidth-viewDir*_toWidth)
		var t0 = i/_points.size()
		var t1 = t
		mesh.surface_set_uv(Vector2(t0, 0))
		mesh.surface_add_vertex(to_local(_points[i]+currWidth))
		mesh.surface_set_uv(Vector2(t1, 1))
		mesh.surface_add_vertex(to_local(_points[i]-currWidth))
	mesh.surface_end()
