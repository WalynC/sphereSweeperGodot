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
@export var backgroundColor := Color.DARK_TURQUOISE

static var menuSphereNeedsUpdating = false

func LoadVisualTheme():
	instance = self
	RenderingServer.global_shader_parameter_set_override("BorderColor", borderColor)
	VisualLoader.instance.controlRoot.theme = theme
	VisualLoader.instance.worldEnv.environment.background_color = backgroundColor
	match VisualLoader.instance.scene:
		VisualLoader.SceneType.MainMenu:
			LoadMainMenuVisuals()
		VisualLoader.SceneType.Game:
			LoadGameVisuals()
		VisualLoader.SceneType.Tutorial:
			LoadGameVisuals()

func InitialLoad(): #called when theme is changed
	RenderingServer.set_default_clear_color(backgroundColor)

func UnloadVisualTheme():
	match VisualLoader.instance.scene:
		VisualLoader.SceneType.MainMenu:
			UnloadMainMenuVisuals()
		VisualLoader.SceneType.Game:
			UnloadGameVisuals()
		VisualLoader.SceneType.Tutorial:
			UnloadGameVisuals()

func UnloadMainMenuVisuals():
	pass

func UnloadGameVisuals():
	pass

func LoadMainMenuVisuals():
	if (menuSphereNeedsUpdating): VisualLoader.instance.mainMenuUI.mainMenuSphere.UpdateColors()

func LoadGameVisuals():
	if (GameManager.instance.board.vertices.size() > 0): GameManager.instance.board.BuildBoardVisuals()

func GetBaseColor_int(i):
	return GetBaseColor(GameManager.instance.board.vertices[i])

func GetBaseColor(vector):
	return Color(lerpf(0, 1, VisualTheme.invlerp(-gold, gold, vector.x)),lerpf(0, 1, VisualTheme.invlerp(-gold, gold, vector.y)),lerpf(0, 1, VisualTheme.invlerp(-gold, gold, vector.z)))

func GetClearedColor(_vector):
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
