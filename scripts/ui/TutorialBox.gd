extends Control


func _ready():
	set_deferred("size", get_parent_control().size*2)
	set_deferred("position", Vector2(0,-get_parent_control().size.y))
	pass
