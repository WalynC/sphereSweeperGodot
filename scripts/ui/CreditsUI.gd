extends Control

@export var uiTransition : UITransition
@export var mainMenuUI : Control

func back_button_pressed():
	VisualTheme.instance.buttonPress.play()
	uiTransition.exit_screen().tween_callback(mainMenuUI.enter_screen)

func enter_screen():
	uiTransition.enter_screen()

func _ready():
	pass
	set_deferred("size", get_parent_control().size*2)
	set_deferred("position", Vector2(0,get_parent_control().size.y))
