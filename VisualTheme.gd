extends Node
class_name VisualTheme

static var themePath: PackedScene #res path to theme being used
static var themeInstance: VisualTheme #instance of visual theme

enum SceneType {MainMenu, Game, Tutorial}
enum UIType {MainMenu, NewGameBasic, CustomGame, Game, Pause, Win, Lose}

@export var scenes: Array[PackedScene] #UI scenes that need to be instantiated, should correspond to UIType
var instances: Array[Control] #instances of scenes

static var currentScene: SceneType

func _ready():
	InitScene(currentScene)

static func Init(tree):
	print("Init")
	themePath = preload("res://visualThemes/testTheme.tscn")
	themeInstance = themePath.instantiate()
	tree.root.add_child.call_deferred(themeInstance)
	themeInstance.instances.resize(themeInstance.scenes.size())

static func InitScene(sceneType:SceneType):
	print("InitScene")
	match sceneType:
		SceneType.MainMenu:
			themeInstance.instances[UIType.MainMenu] = themeInstance.scenes[UIType.MainMenu].instantiate()
			themeInstance.add_child(themeInstance.instances[UIType.MainMenu])
			themeInstance.instances[UIType.MainMenu].position = Vector2(-600,0)
			Enter(UIType.MainMenu)
		_:
			pass

static func Enter(en:UIType):
	#Make ui "en" enter view
	match en:
		UIType.MainMenu:
			var tween = themeInstance.instances[en].create_tween()
			tween.tween_property(themeInstance.instances[en], "position", Vector2(0, 0), 1)
			pass
		_:
			pass

static func Exit(ex:UIType, en:UIType):
	#Make ui "ex" exit view, then after done, call Enter(en)
	match ex:
		_:
			pass

static func ChangeScene(scene:SceneType):
	#Move current UI away, then after done, load new scene
	pass
