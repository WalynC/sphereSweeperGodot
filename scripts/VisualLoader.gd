extends Node
class_name VisualLoader

static var theme = -1

enum SceneType {MainMenu, Game, Tutorial}
@export var scene : SceneType

@export var themePaths: Array[PackedScene]
@export var themeNames: Array[String]
@export var controlRoot: Control
@export var mainMenuUI : Control
@export var worldEnv : WorldEnvironment

static var instance

func _ready():
	init()

func init():
	instance = self

func GetCurrentThemeName():
	return themeNames[theme]

func loadTheme():
	var tInst = themePaths[theme].instantiate()
	add_child(tInst)
	tInst.LoadVisualTheme()

func unloadTheme():
	if (VisualTheme.instance == null): return
	VisualTheme.instance.UnloadVisualTheme()
	VisualTheme.instance.queue_free()

func change_button_pressed(increase):
	var next = 1
	if !increase: next = -1
	changeTheme((theme+next)%themePaths.size())

func changeTheme(i):
	if (i == theme): return
	unloadTheme()
	if (scene != SceneType.MainMenu):
		GameManager.instance.reset_visual_rng()
	theme = i
	loadTheme()
	VisualTheme.instance.InitialLoad()
