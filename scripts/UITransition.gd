extends Control
class_name UITransition
@export var control : Control
var blocker : Control

func _ready():
	blocker = get_node("../../blocker")

func exit_screen():
	blocker.mouse_filter = Control.MOUSE_FILTER_STOP
	var tween = create_tween()
	tween.tween_property(control, "position", Vector2(0,control.get_parent_control().size.y),.5)
	return tween

func enter_screen():
	var tween = create_tween()
	tween.tween_property(control, "position", Vector2(0,0),.5)
	tween.tween_callback(disableBlocker)
	return tween

func disableBlocker():
	blocker.mouse_filter = Control.MOUSE_FILTER_IGNORE
