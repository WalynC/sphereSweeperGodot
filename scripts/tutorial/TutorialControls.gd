extends Controls

class_name TutorialControls

var allowSelect = true
var selectStep = null
var tapStep = null

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
			var endHit = GetTriangleHit(event.position)
			if (triangleHit == endHit):
				if (selectStep != null && selectStep.movesNeeded.contains(triangleHit)):
					CompleteTap()
				elif (tapStep != null && tapStep.movesNeeded.contains(triangleHit)):
					tapStep.movesNeeded.Remove(triangleHit)
					tapStep.Check()
					
			touch_points.erase(event.index)
	
	if touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		start_distance = touch_point_positions[0].distance_to(touch_point_positions[1])
		start_zoom = cam.fov
	elif touch_points.size() < 2:
		start_distance = 0

func CompleteTap():
	if (gm.paused): return
	GameManager.instance.glowMesh.Add(GameManager.instance.board.triangles[triangleHit], {GameManager.instance.board.triangles[triangleHit]:null})
	if flag:
		Flag()
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
	SelectIndicator.inst.EndIndicate()
