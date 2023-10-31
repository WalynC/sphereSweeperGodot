extends Node3D

class_name Controls

@export var gm: Node3D
@export var pivot: Node3D
@export var confirmButton: CanvasItem

var cam
var touch_points = {}
var touch_ending = {}
var start_distance
var start_zoom

static var instance:Controls

var inertia = Vector2.ZERO
var decel = 1

var triangleHit = -1
var previousTriangleHit = -1

var flag = false
var neighborSelect = 0
var confirmSelect = 2

func SetFlag(val):
	flag = val

func _ready():
	instance = self
	cam = get_viewport().get_camera_3d()
	confirmButton.visible = confirmSelect == 2

func ChangeNeighborSelect():
	neighborSelect += 1
	if (neighborSelect > 2): neighborSelect = 0

func _process(delta):
	pivot.rotate(to_global(cam.get_camera_transform().basis.x), inertia.y)
	pivot.rotate(to_global(cam.get_camera_transform().basis.y), inertia.x)
	inertia = inertia.move_toward(Vector2.ZERO, decel * delta)
	confirmButton.disabled = previousTriangleHit == -1
	if Input.is_action_pressed("scroll_down"): cam.fov -=1
	if Input.is_action_pressed("scroll_up"): cam.fov +=1

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		handle_touch(event)
	elif event is InputEventScreenDrag:
		handle_drag(event)

func handle_touch(event: InputEventScreenTouch):
	if event.pressed:
		inertia = Vector2.ZERO
		touch_points[event.index] = event.position
		if (touch_points.size() == 1):
			triangleHit = GetTriangleHit(event.position)
			if (triangleHit < 0):
				ResetTriangleHit()
	else:
		var endHit = GetTriangleHit(event.position)
		if (triangleHit == endHit):
			CompleteTap()
		touch_points.erase(event.index)
	
	if touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		start_distance = touch_point_positions[0].distance_to(touch_point_positions[1])
		start_zoom = cam.fov
	elif touch_points.size() < 2:
		start_distance = 0
	
func handle_drag(event: InputEventScreenDrag):
	touch_points[event.index] = event.position
	if touch_points.size() == 1:
		inertia = event.relative * -0.005
		pivot.rotate(to_global(cam.get_camera_transform().basis.x), inertia.y)
		pivot.rotate(to_global(cam.get_camera_transform().basis.y), inertia.x)
	elif touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		var curDist = touch_point_positions[0].distance_to(touch_point_positions[1])
		var zoom_factor = start_distance/curDist
		cam.fov = start_zoom/zoom_factor

func CompleteTap():
	if flag:
		Flag()
	else:
		match confirmSelect:
			0:
				previousTriangleHit = triangleHit
				Confirm()
			1:
				if (previousTriangleHit != triangleHit):
					previousTriangleHit = triangleHit
				else: Confirm()
			2:
				previousTriangleHit = triangleHit
				pass

func Flag():
	if (neighborSelect == 0):
		gm.board.Flag(triangleHit)
	else:
		if (neighborSelect == 1): neighborSelect = 0 #mode 1 is to only use neighbor select once
		var neighbors = gm.board.triangles[triangleHit].neighbors.duplicate()
		neighbors[gm.board.triangles[triangleHit]] = null
		var unflagged = []
		var flagged = []
		for t in neighbors:
			if (t.reveal): continue
			if (t.flagged): flagged.append(t.vertIndices[0]/3)
			else: unflagged.append(t.vertIndices[0]/3)
		if (unflagged.size() > 0): #only unflag if no unflagged tris were selected
			for i in range(0, unflagged.size()):
				gm.board.Flag(unflagged[i])
		else:
			for i in range(0, flagged.size()):
				gm.board.Flag(flagged[i])

func Confirm():
	if (triangleHit == -1): pass
	Select()
	previousTriangleHit = -1
	
func Select():
	if (!gm.board.boardGenerated):
		gm.board.GenerateNewBoard(triangleHit)
		gm.board.SelectTriangle(triangleHit)
	elif (neighborSelect == 0):
		if (gm.board.triangles[triangleHit].flagged || gm.board.triangles[triangleHit].reveal):
			return
		gm.board.SelectTriangle(triangleHit)
	else:
		if (neighborSelect == 1): neighborSelect = 0 #mode 1 is to only use neighbor select once
		var neighbors = gm.board.triangles[triangleHit].neighbors.duplicate()
		neighbors[gm.board.triangles[triangleHit]] = null
		var indexList = []
		for t in neighbors:
			if (t.flagged || t.reveal): continue
			if (t.mine):
				gm.board.SelectTriangle(t.vertIndices[0]/3)
				return
			indexList.append(t.vertIndices[0]/3)
		if (indexList.size() > 0):
			gm.board.SelectTriangle_List(indexList, triangleHit)
		else:
			pass#will have "bad select" sound when it is time to add sounds

func ResetTriangleHit():
	triangleHit = -1
	previousTriangleHit = -1

func GetTriangleHit(pos):
	var worldspace = get_world_3d().direct_space_state
	var start = cam.project_ray_origin(pos)
	var end = cam.project_position(pos, 1000)
	var para = PhysicsRayQueryParameters3D.new()
	para.from = start
	para.to = end
	var result = worldspace.intersect_ray(para)
	if result != null and result.size() > 0:
		var triangleHit = GetHitMeshTriangleFaceIndex(result["position"], start)
		return triangleHit
	return -999

func GetHitMeshTriangleFaceIndex(hitVector, start):
	var vertices = gm.mainMesh.mesh.get_faces()
	var arrayMesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrayMesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	var meshDataTool = MeshDataTool.new()
	meshDataTool.create_from_surface(arrayMesh,0)
	var cameraOrigin = start
	var purpleArrow = hitVector - cameraOrigin
	var i = 0
	while i < vertices.size():
		var faceIndex = i/3
		var a = to_global(vertices[i])
		var b = to_global(vertices[i+1])
		var c = to_global(vertices[i+2])
		var intersectsTriangle = Geometry3D.ray_intersects_triangle(cameraOrigin,purpleArrow,a,b,c)
		if intersectsTriangle != null:
			var angle = rad_to_deg(purpleArrow.angle_to(to_global(meshDataTool.get_face_normal(faceIndex))))
			if angle > 90 and angle < 180: return faceIndex
		i+=3
	return -999
