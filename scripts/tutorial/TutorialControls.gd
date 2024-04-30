extends Controls

class_name TutorialControls

var allowSelect = false
var selectStep = null
var tapStep = null

@export var tIndicator : TutorialIndicator

func handle_touch(event: InputEventScreenTouch):
	if event.pressed:
		inertia = Vector2.ZERO
		WindSound.instance.Spin(.5, 1, true)
		touch_points[event.index] = event.position
		if (touch_points.size() == 1 && !confirmDown):
			triangleHit = GetTriangleHit(event.position)
			if (triangleHit < 0):
				ResetTriangleHit()
				sIndicator.EndIndicate()
	else:
		if (allowSelect):
			var endHit = GetTriangleHit(event.position)
			if ((selectStep != null && selectStep.movesNeeded.has(endHit)) || (tapStep != null && tapStep.movesNeeded.has(endHit))):
				if (triangleHit == endHit):
					GameManager.instance.glowMesh.Add(GameManager.instance.board.triangles[triangleHit], {GameManager.instance.board.triangles[triangleHit]:null})
					if (selectStep != null && selectStep.movesNeeded.has(triangleHit)):
						CompleteTap()
					elif (tapStep != null && tapStep.movesNeeded.has(triangleHit)):
						tapStep.EraseStep(triangleHit)
						tapStep.Check()
						VisualTheme.instance.buttonPress.play()
			else:
				ResetTriangleHit()
				sIndicator.EndIndicate()
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
		selectStep.EraseStep(triangleHit) #we are on a flag step, so remove flag
		selectStep.Check()
		VisualTheme.instance.buttonPress.play()
	else:
		sIndicator.EndIndicate()
		match confirmSelect:
			0:
				previousTriangleHit = triangleHit
				Confirm()
			1:
				if (previousTriangleHit != triangleHit):
					VisualTheme.instance.buttonPress.play()
					previousTriangleHit = triangleHit
					if (neighborSelect > 0): sIndicator.IndicateNeighbors(gm.board.triangles[triangleHit])
					else: sIndicator.Indicate(gm.board.triangles[triangleHit])
				else: Confirm()
			2:
				VisualTheme.instance.buttonPress.play()
				previousTriangleHit = triangleHit
				if (neighborSelect > 0): sIndicator.IndicateNeighbors(gm.board.triangles[triangleHit])
				else: sIndicator.Indicate(gm.board.triangles[triangleHit])

func Confirm():
	if (triangleHit < 0): return
	Select()
	previousTriangleHit = -1
	selectStep.EraseStep(triangleHit)
	selectStep.Check()
	sIndicator.EndIndicate()
