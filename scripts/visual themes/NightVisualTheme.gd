extends VisualTheme

@export var randomColors : Array[Color]
var randomCount = 0
var randColor = Color.RED


func GetBaseColor(vector):
	if (randomCount == 0):
		randomCount = 3
		randColor = randomColors[GameManager.visRNG.randi_range(0,randomColors.size()-1)]
	randomCount-=1
	return randColor
