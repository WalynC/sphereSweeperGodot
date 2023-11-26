extends VisualTheme

func LoadGameVisuals():
	if (GameManager.instance.board.vertices.size() > 0): GameManager.instance.board.BuildBoardVisuals()
	print("loading day game visuals")

func UnloadGameVisuals():
	print("unloading day game visuals")

func GetBaseColor(vector):
	return Color(smoothstep(0, 1, invlerp(-gold, gold, vector.x)),smoothstep(0, 1, invlerp(-gold, gold, vector.y)),smoothstep(0, 1, invlerp(-gold, gold, vector.z)))

func GetClearedColor(vector):
	return Color(smoothstep(1, 0, invlerp(-gold, gold, vector.x)),smoothstep(1, 0, invlerp(-gold, gold, vector.y)),smoothstep(1, 0, invlerp(-gold, gold, vector.z)))
