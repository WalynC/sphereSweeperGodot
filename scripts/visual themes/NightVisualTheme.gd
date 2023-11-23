extends VisualTheme

@export var randomColors : Array[Color]
var randomCount = 0
var randColor = Color.RED

func LoadVisualTheme():
	instance = self
	VisualLoader.instance.controlRoot.theme = theme
	match VisualLoader.instance.scene:
		VisualLoader.SceneType.MainMenu:
			LoadMainMenuVisuals()
		VisualLoader.SceneType.Game:
			LoadGameVisuals()

func UnloadVisualTheme():
	match VisualLoader.instance.scene:
		VisualLoader.SceneType.MainMenu:
			UnloadMainMenuVisuals()
		VisualLoader.SceneType.Game:
			UnloadGameVisuals()

func GetBaseColor_int(i):
	return GetBaseColor(GameManager.instance.board.vertices[i])

func GetBaseColor(vector):
	if (randomCount == 0):
		randomCount = 3
		randColor = randomColors[GameManager.instance.visRNG.randi_range(0,randomColors.size()-1)]
	randomCount-=1
	return randColor

static func invlerp(a, b, v):
	return (v-a)/(b-a)

static func won():
	instance.emit_signal("win")

static func endwon():
	instance.emit_signal("endWon")

static func lost():
	instance.emit_signal("lose")

static func endlost():
	instance.emit_signal("endLose")
