extends VisualTheme

@export var randomColors : Array[Color]
var randomCount = 0
var randColor = Color.RED

@export var starLoader : StarLoader

func GetBaseColor(vector):
	if (randomCount == 0):
		randomCount = 3
		randColor = randomColors[GameManager.visRNG.randi_range(0,randomColors.size()-1)]
	randomCount-=1
	return randColor

func GetClearedColor(vector):
	return Color.BLACK
	
func LoadGameVisuals():
	if (GameManager.instance.board.vertices.size() > 0): GameManager.instance.board.BuildBoardVisuals()
	starLoader.Generate()
	print("loading night game visuals")

func UnloadGameVisuals():
	starLoader.Cleanup()
	print("unloading night game visuals")
