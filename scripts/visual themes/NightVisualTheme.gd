extends VisualTheme

@export var randomColors : Array[Color]
var randomCount = 0
var randColor = Color.RED

@export var starLoader : StarLoader
@export var explosionEffect : ExplosionEffect

func GetBaseColor(_vector):
	if (randomCount == 0):
		randomCount = 3
		randColor = randomColors[GameManager.visRNG.randi_range(0,randomColors.size()-1)]
	randomCount-=1
	return randColor

func GetClearedColor(_vector):
	return Color.BLACK

func LoadGameVisuals():
	if (GameManager.instance.board.vertices.size() > 0): GameManager.instance.board.UpdateColors()
	starLoader.Generate()
	explosionEffect.PreloadExplosions()

func UnloadGameVisuals():
	starLoader.Cleanup()
	explosionEffect.Cleanup()
