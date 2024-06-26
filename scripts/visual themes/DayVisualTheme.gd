extends VisualTheme

@export var clouds : PackedScene
var cloudInstance

func LoadGameVisuals():
	if (GameManager.instance.board.vertices.size() > 0): GameManager.instance.board.BuildBoardVisuals()
	GameManager.instance.mainMesh.set_instance_shader_parameter("BorderColor", borderColor)
	cloudInstance = clouds.instantiate()
	add_child(cloudInstance)
	cloudInstance.GenerateClouds()

func UnloadGameVisuals():
	cloudInstance.Cleanup()
	cloudInstance.queue_free()

func GetBaseColor(vector):
	return Color(smoothstep(0, 1, VisualTheme.invlerp(-gold, gold, vector.x)),smoothstep(0, 1, VisualTheme.invlerp(-gold, gold, vector.y)),smoothstep(0, 1, VisualTheme.invlerp(-gold, gold, vector.z)))

func GetClearedColor(vector):
	return Color(smoothstep(1, 0, VisualTheme.invlerp(-gold, gold, vector.x)),smoothstep(1, 0, VisualTheme.invlerp(-gold, gold, vector.y)),smoothstep(1, 0, VisualTheme.invlerp(-gold, gold, vector.z)))
