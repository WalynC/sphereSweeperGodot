extends Node
class_name VisualLoader

static var theme = 0

enum SceneType {Main, Game, Tutorial}
@export var scene : SceneType

@export var themePaths: Array[PackedScene]
@export var controlRoot: Control

static var instance


func _ready():
	instance = self
	#load visual theme and tell it to process
	var tInst = themePaths[theme].instantiate()
	add_child(tInst)
	tInst.LoadVisualTheme()
