extends Control


@export var modeButtons: Array[Button]
var called = false
@export var previousUI:Control
@export var volText:RichTextLabel
@export var volSlider:Slider

func _ready():
	for i in range(0,3):
		modeButtons[i].button_pressed = false
	modeButtons[Controls.confirmSelect].button_pressed = true
	volText.text = "Volume: "+str(int(UserSettings.volume))
	volSlider.value = UserSettings.volume


func volume_changed(vol):
	volText.text = "Volume: "+str(int(vol))
	UserSettings.volume = int(vol)
	AudioServer.set_bus_volume_db(0,linear_to_db(lerpf(0,1,vol/100)))

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

func change_theme_pressed(val):
	VisualLoader.instance.change_button_pressed(val)

func back_button_pressed():
	exit_screen().tween_callback(previousUI.enter_screen)
