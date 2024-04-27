extends Controls

class_name TutorialControls

var allowSelect = true
var selectStep = null
var tapStep = null

@export var test : int

func handle_touch(event: InputEventScreenTouch):
	if event.pressed:
		inertia = Vector2.ZERO
		WindSound.instance.Spin(.5, 1, true)
		touch_points[event.index] = event.position
		if (touch_points.size() == 1):
			triangleHit = GetTriangleHit(event.position)
			if (triangleHit < 0):
				ResetTriangleHit()
				SelectIndicator.inst.EndIndicate()
	else:
		if (allowSelect):
			print("allowSelect")
			var endHit = GetTriangleHit(event.position)
			if (triangleHit == endHit):
				GameManager.instance.glowMesh.Add(GameManager.instance.board.triangles[triangleHit], {GameManager.instance.board.triangles[triangleHit]:null})
				if (selectStep != null && selectStep.movesNeeded.has(triangleHit)):
					CompleteTap()
				elif (tapStep != null && tapStep.movesNeeded.has(triangleHit)):
					tapStep.moves.erase(triangleHit)
					tapStep.Check()
					VisualTheme.instance.buttonPress.play()
		touch_points.erase(event.index)
	
	if touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		start_distance = touch_point_positions[0].distance_to(touch_point_positions[1])
		start_zoom = cam.fov
	elif touch_points.size() < 2:
		start_distance = 0

func CompleteTap():
	if (gm.paused): return
	if flag:
		Flag()
		selectStep.moves.erase(triangleHit) #we are on a flag step, so remove flag
		selectStep.Check()
		VisualTheme.instance.buttonPress.play()
	else:
		SelectIndicator.inst.EndIndicate()
		match confirmSelect:
			0:
				previousTriangleHit = triangleHit
				Confirm()
			1:
				if (previousTriangleHit != triangleHit):
					VisualTheme.instance.buttonPress.play()
					previousTriangleHit = triangleHit
					if (neighborSelect > 0): SelectIndicator.inst.IndicateNeighbors(gm.board.triangles[triangleHit])
					else: SelectIndicator.inst.Indicate(gm.board.triangles[triangleHit])
				else: Confirm()
			2:
				VisualTheme.instance.buttonPress.play()
				previousTriangleHit = triangleHit
				if (neighborSelect > 0): SelectIndicator.inst.IndicateNeighbors(gm.board.triangles[triangleHit])
				else: SelectIndicator.inst.Indicate(gm.board.triangles[triangleHit])

func Confirm():
	if (triangleHit == -1): return
	Select()
	previousTriangleHit = -1
	selectStep.moves.erase(triangleHit)
	selectStep.Check()
	SelectIndicator.inst.EndIndicate()
