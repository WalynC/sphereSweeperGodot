extends Resource
class_name SaveData

@export var size:int
@export var mines:int
@export var nonMines:int
@export var mineHit:bool
@export var firstSelected:int
@export var flagged:Dictionary
@export var rot:Basis
@export var zoom:float
@export var time:float
@export var percentMined:float
@export var gameSeed:int
@export var visualSeed:int
@export var selected:Array
@export var selectArr:Array
@export var flagActs:Array
@export var visualTime:float

func ToData():
	var flagActsData = []
	for i in range(0, flagActs.size()):
		flagActsData.append(flagActs[i].ToData())
	var data = {
		"size":size,
		"mines":mines,
		"nonMines":nonMines,
		"firstSelected":firstSelected,
		"flagged":flagged,
		"rot":rot,
		"zoom":zoom,
		"time":time,
		"percentMined":percentMined,
		"gameSeed":gameSeed,
		"visualSeed":visualSeed,
		"selected":selected,
		"selectArr":selectArr,
		"flagActs":flagActsData,
		"visualTime":visualTime
	}
	return data

func LoadFromData(data):
	flagActs.clear()
	for i in range(0, data.flagActs.size()):
		var act = FlagAction.new()
		act.FromData(data.flagActs[i])
		flagActs.append(act)
	size = data.size
	mines = data.mines
	nonMines = data.nonMines
	firstSelected = data.firstSelected
	var flaggedString = data.flagged
	for i in flaggedString: flagged[int(i)]=null
	rot = StringToBasis(data.rot)
	zoom = data.zoom
	time = data.time
	percentMined = data.percentMined
	gameSeed = data.gameSeed
	visualSeed = data.visualSeed
	selected = data.selected
	selectArr = data.selectArr
	visualTime = data.visualTime

func StringToBasis(input):
	var slices = input.split(')')
	slices[0]=slices[0].erase(0, 5)
	slices[1]=slices[1].erase(0, 6)
	slices[2]=slices[2].erase(0, 6)
	var xSlices = slices[0].split_floats(",")
	var x = Vector3(xSlices[0],xSlices[1],xSlices[2])
	var ySlices = slices[1].split_floats(",")
	var y = Vector3(ySlices[0],ySlices[1],ySlices[2])
	var zSlices = slices[2].split_floats(",")
	var z = Vector3(zSlices[0],zSlices[1],zSlices[2])
	var res = Basis(x,y,z)
	return res
