extends Control
class_name UITransition
@export var control : Control

func exit_screen():
	var tween = create_tween()
	tween.tween_property(control, "position", Vector2(0,control.get_parent_control().size.y),.5)
	return tween

func enter_screen():
	var tween = create_tween()
	tween.tween_property(control, "position", Vector2(0,0),.5)
	return tween
