extends VisualTheme

@export var clouds : PackedScene
var cloudInstance
@export var explosionEffect : ExplosionEffect

func LoadGameVisuals():
	if (GameManager.instance.board.vertices.size() > 0): GameManager.instance.board.UpdateColors()
	cloudInstance = clouds.instantiate()
	add_child(cloudInstance)
	explosionEffect.PreloadExplosions()
	cloudInstance.GenerateClouds()

func UnloadGameVisuals():
	cloudInstance.Cleanup()
	cloudInstance.queue_free()
	explosionEffect.Cleanup()

func GetBaseColor(vector):
	return Color(smoothstep(0, 1, VisualTheme.invlerp(-gold, gold, vector.x)),smoothstep(0, 1, VisualTheme.invlerp(-gold, gold, vector.y)),smoothstep(0, 1, VisualTheme.invlerp(-gold, gold, vector.z)))

func GetClearedColor(vector):
	return Color(smoothstep(1, 0, VisualTheme.invlerp(-gold, gold, vector.x)),smoothstep(1, 0, VisualTheme.invlerp(-gold, gold, vector.y)),smoothstep(1, 0, VisualTheme.invlerp(-gold, gold, vector.z))) *.5
