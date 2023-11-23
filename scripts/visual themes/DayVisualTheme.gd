extends VisualTheme

func GetBaseColor(vector):
	return Color(lerpf(0, 1, invlerp(-gold, gold, vector.x)),lerpf(0, 1, invlerp(-gold, gold, vector.y)),lerpf(0, 1, invlerp(-gold, gold, vector.z)))
