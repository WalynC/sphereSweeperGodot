extends Node
class_name VisualLoader

static var theme = 0

enum SceneType {MainMenu, Game, Tutorial}
@export var scene : SceneType

@export var themePaths: Array[PackedScene]
@export var controlRoot: Control

static var instance


func _ready():
	if (instance != self): init()

func init():
	instance = self
	#load visual theme and tell it to process
	loadTheme()

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
	theme = i
	loadTheme()
