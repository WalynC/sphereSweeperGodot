extends TutorialStep
class_name ZoomStep

@export var zoomTarget : Camera3D
@export var controls : TutorialControls

var outReq
var inReq
var zoomedIn = false
var zoomedOut = false
var req = 3.0

func Begin():
	checkUpdate = true
	var start = zoomTarget.fov
	outReq = clampf(start + req, controls.minZoom, controls.maxZoom)
	inReq = clampf(start - req, controls.minZoom, controls.maxZoom)

func Check():
	zoomedOut |= zoomTarget.fov <= inReq
	zoomedIn |= zoomTarget.fov >= outReq
	if (zoomedOut && zoomedIn): End()
