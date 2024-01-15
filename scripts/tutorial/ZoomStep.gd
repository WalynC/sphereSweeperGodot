extends TutorialStep
class_name ZoomStep

@export var zoomTarget : Camera3D
@export var controls : TutorialControls

var outReq
var inReq
var zoomedIn = false
var zoomedOut = false
@export var req : float = 3.0

func Begin():
	checkUpdate = true
	var start = zoomTarget.fov
	outReq = clampf(start + req, controls.minZoom, controls.maxZoom)
	inReq = clampf(start - req, controls.minZoom, controls.maxZoom)

func Check():
	zoomedIn = zoomedIn || (zoomTarget.fov <= inReq)
	zoomedOut = zoomedOut || (zoomTarget.fov >= outReq)
	if (zoomedOut && zoomedIn): End()
