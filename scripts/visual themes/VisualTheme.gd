extends Node
class_name VisualTheme

static var instance : VisualTheme

signal win
signal endWon
signal lose
signal endLose

const gold = (1 + sqrt(5))/2

@export var numberColors : Array[Color]
@export var theme : Theme
@export var buttonPress : AudioStreamPlayer
@export var failSelect : AudioStreamPlayer
@export var select : AudioStreamPlayer
@export var borderColor := Color.BLACK

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

func UnloadMainMenuVisuals():
	pass

func UnloadGameVisuals():
	pass

func LoadMainMenuVisuals():
	pass

func LoadGameVisuals():
	if (GameManager.instance.board.vertices.size() > 0): GameManager.instance.board.BuildBoardVisuals()

func GetBaseColor_int(i):
	return GetBaseColor(GameManager.instance.board.vertices[i])

func GetBaseColor(vector):
	return Color(lerpf(0, 1, invlerp(-gold, gold, vector.x)),lerpf(0, 1, invlerp(-gold, gold, vector.y)),lerpf(0, 1, invlerp(-gold, gold, vector.z)))

func GetClearedColor(vector):
	return Color.DIM_GRAY

func GetClearedColor_int(i):
	return GetClearedColor(GameManager.instance.board.vertices[i])

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
