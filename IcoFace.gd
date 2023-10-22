class_name IcoFace

var count = 0
var lines = []
var corners = []
var lineNeighbors = []
var lineNeighborFlip = []
var cornerNeighbors = {}
var points:PackedInt32Array

static func create(pointCount):
	var inst = IcoFace.new()
	inst.points.resize(pointCount)
	inst.lines.resize(3)
	inst.corners.resize(3)
	inst.lineNeighbors.resize(3)
	inst.lineNeighborFlip.resize(3)
	for i in range(0,pointCount):
		inst.points[i] = -1
	return inst

func AssignLineNeighbor(flip, neighbor, index):
	var line = lines[index]
	if flip:
		line = Vector2i(line.y, line.x)
	var neighborIndex = 0
	if neighbor.lines[1] == line:
		neighborIndex = 1
	elif neighbor.lines[2] == line:
		neighborIndex = 2
	neighbor.lineNeighborFlip[neighborIndex] = flip
	lineNeighborFlip[index] = flip
	lineNeighbors[index] = neighbor
	neighbor.lineNeighbors[neighborIndex] = self

func GetCornerValue(corner, subdivAmount):
	if (corners[0]==corner):
		return points[0]
	if (corners[1]==corner):
		return points[points.size() - subdivAmount - 1]
	if (corners[2]==corner):
		return points[points.size()-1]
	return -1
	
func SetCornerValue(corner, subdivAmount,value):
	if (corners[0]==corner):
		points[0] = value
	elif(corners[1]==corner):
		points[points.size()-subdivAmount-1]=value
	else:
		points[points.size()-1]=value
		
func GetLinePoints(line,subdiv,board):
	var neighborPoints = []
	neighborPoints.resize(subdiv-1)
	var r = range(1,neighborPoints.size()+1)
	if line==lines[0]: #left
		for k in r:
			neighborPoints[k-1]=points[board.leftSidePointIndex[k]]
	elif(line==lines[1]): #bottom
		for k in r:
			neighborPoints[k-1]=points[points.size()-1-k]
	else: #right
		for k in r:
			neighborPoints[k-1]=points[board.rightSidePointIndex[k]]
	return neighborPoints
	
func SetLinePoints(line,flip,neighborPoints,board):
	var r = range(1,neighborPoints.size()+1)
	if flip:
		line = Vector2i(line.y, line.x)
	if line==lines[0]: #left
		for k in r:
			points[board.leftSidePointIndex[k]]=neighborPoints[k-1]
	elif(line==lines[1]): #bottom
		for k in r:
			points[points.size()-1-k]=neighborPoints[k-1]
	else: #right
		for k in r:
			points[board.rightSidePointIndex[k]]=neighborPoints[k-1]
	
