extends Node

@export var sceneType : VisualTheme.SceneType

# Called when the node enters the scene tree for the first time.
func _ready():
	VisualTheme.currentScene = sceneType
	VisualTheme.Init(get_tree())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
