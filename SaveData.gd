extends Resource
class_name SaveData

@export var size:int
@export var mines:int
@export var nonMines:int
@export var mineHit:bool
@export var firstSelected:int
@export var flagged:Dictionary
@export var rot:Vector3
@export var zoom:float
@export var time:float
@export var percentMined:float
@export var seed:int
@export var visualSeed:int
@export var selected:Array
@export var selectArr:Array
@export var flagActs:Array
@export var timeBeforeFirstSelect:float

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
		"seed":seed,
		"visualSeed":visualSeed,
		"selected":selected,
		"selectArr":selectArr,
		"flagActs":flagActsData,
		"timeBeforeFirstSelect":timeBeforeFirstSelect
	}
	return data

func LoadFromData(data):
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
	var rotStrings = data.rot.split_floats(",")
	rot = Vector3(rotStrings[0],rotStrings[1],rotStrings[2])
	zoom = data.zoom
	time = data.time
	percentMined = data.percentMined
	seed = data.seed
	visualSeed = data.visualSeed
	selected = data.selected
	selectArr = data.selectArr
	timeBeforeFirstSelect = data.timeBeforeFirstSelect
