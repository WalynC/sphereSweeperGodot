class_name FlagAction

static var currentFlagAct:FlagAction
static var newFlags:Dictionary
static var newUnflags:Dictionary
var flagRanges:Array
var unflagRanges:Array

static func Start():
	currentFlagAct = FlagAction.new()
	SaveManager.saveData.flagActs.append(currentFlagAct)

func Load(gm):
	for ran in flagRanges:
		for i in range(ran.x, ran.y+1):
			gm.board.triangles[i].flagged = true
	for ran in unflagRanges:
		for i in range(ran.x, ran.y+1):
			gm.board.triangles[i].flagged = false

func LoadPending(gm): #used for loading current flag act
	currentFlagAct = self
	for ran in flagRanges:
		for i in range(ran.x, ran.y+1):
			gm.board.triangles[i].flagged = true
			newFlags[i] = null
	for ran in unflagRanges:
		for i in range(ran.x, ran.y+1):
			gm.board.triangles[i].flagged = false
			newUnflags[i] = null

func Change(gm, tri):
	if gm.board.triangles[tri].flagged:
		if newUnflags.has(tri):
			RemoveInt(tri,true)
			newUnflags.erase(tri)
			SaveManager.saveData.flagged[tri]=null
		else:
			AddInt(tri,false)
			newFlags[tri] = null
			SaveManager.saveData.flagged[tri]=null
	else:
		if newFlags.has(tri):
			RemoveInt(tri,false)
			newFlags.erase(tri)
			SaveManager.saveData.flagged.erase(tri)
		else:
			AddInt(tri,true)
			newUnflags[tri] = null
			SaveManager.saveData.flagged.erase(tri)

func AddInt(add,unflag):
	var ranges = unflagRanges if unflag else flagRanges
	for i in range(0,ranges.size()):
		var ran = ranges[i]
		if (add < ranges[i].x - 1): #cant reach next range
			ranges.insert(i, Vector2i(add,add))
			return
		elif (add<=ranges[i].y+1): #either in range or new y range
			if (add == ranges[i].x-1): #new x range
				ran.x = add
				ranges[i] = ran
			elif add == ranges[i].y+1: #addition is on end of range, may connect to next range
				if (i < ranges.size()-1 && ranges[i+1].x - 1 == add): #merge two ranges
					ran.y = ranges[i+1].y
					ranges[i] = ran
					ranges.remove_at(i+1)
				else: #new y range
					ran.y = add
					ranges[i] = ran
			return
	ranges.append(Vector2i(add,add))

func RemoveInt(rem,unflag):
	var ranges = unflagRanges if unflag else flagRanges
	for i in range(0,ranges.size()):
		var ran = ranges[i]
		if (rem < ranges[i].x): return #all ranges ahead greater
		if rem == ranges[i].x:
			ran.x +=1
			if (ran.x > ran.y): ranges.remove_at(i)
			else: ranges[i] = ran
			return
		elif rem == ranges[i].y:
			ran.y-=1
			if (ran.x > ran.y): ranges.remove_at(i)
			else: ranges[i] = ran
			return
		elif rem > ranges[i].x && rem < ranges[i].y: #removed int in middle of range, splitting
			var newRange = Vector2i(ranges[i].x, rem - 1)
			ran.x = rem + 1
			ranges[i] = ran
			ranges.insert(i, newRange)
			return

func ToString():
	var s = ""
	for i in range(0,flagRanges.size()):
		s +=str(flagRanges[i])
	s += "|"
	for i in range(0,unflagRanges.size()):
		s +=str(unflagRanges[i])
	return s

func ToData():
	var data = {
		"flagRanges": flagRanges,
		"unflagRanges": unflagRanges
	}
	return data

func FromData(data):
	var sflagRanges = data.flagRanges
	for i in sflagRanges:
		var split = i.split(",")
		flagRanges.append(Vector2i(int(split[0]), int(split[1])))
	var sunflagRanges = data.unflagRanges
	for i in sunflagRanges:
		var split = i.split(",")
		unflagRanges.append(Vector2i(int(split[0]), int(split[1])))
