extends Node
class_name VisualLoader

static var theme = 0

enum SceneType {MainMenu, Game, Tutorial}
@export var scene : SceneType

@export var themePaths: Array[PackedScene]
@export var controlRoot: Control

static var instance

func _ready():
	if (scene == SceneType.MainMenu):
		init()
		loadTheme()

func init():
	instance = self

func loadTheme():
	var tInst = themePaths[theme].instantiate()
	add_child(tInst)
	tInst.LoadVisualTheme()

func unloadTheme():
	VisualTheme.instance.UnloadVisualTheme()
	VisualTheme.instance.queue_free()

func change_button_pressed(increase):
	var next = 1
	if !increase: next = -1
	changeTheme((theme+next)%themePaths.size())

func changeTheme(i):
	unloadTheme()
	if (scene == SceneType.Game):
		GameManager.instance.reset_visual_rng()
	theme = i
	loadTheme()
