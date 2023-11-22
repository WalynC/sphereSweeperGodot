extends Control


@export var modeButtons: Array[Button]
var called = false
@export var previousUI:Control
@export var volText:RichTextLabel

func volume_changed(vol):
	volText.text = "Volume: "+str(int(vol))

func _change_confirm_mode(_toggle, mode):
	if called: return
	called = true
	Controls.confirmSelect = mode
	for i in range(0,3):
		modeButtons[i].button_pressed = false
	modeButtons[mode].button_pressed = true
	called = false

func enter_screen():
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,0),.5)

func exit_screen():
	UserSettings.SaveOptionsMenuSettings()
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(0,1024),.5)
	return tween
	
func back_button_pressed():
	exit_screen().tween_callback(previousUI.enter_screen)
