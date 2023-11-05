extends Node
class_name VisualTheme

static var themePath: String #res path to theme being used
static var themeInstance: VisualTheme #instance of visual theme

enum SceneType {MainMenu, Game, Tutorial}
enum UIType {MainMenu, NewGameBasic, CustomGame, Game, Pause, Win, Lose}

@export var scenes: Array[Control] #UI scenes that need to be instantiated, should correspond to UIType
var instances: Array[Control] #instances of scenes

static func InitTheme(sceneType:SceneType):
	match sceneType:
		SceneType.MainMenu:
			print("its working")
		_:
			pass

static func Enter(en:UIType):
	#Make ui "en" enter view
	match en:
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
