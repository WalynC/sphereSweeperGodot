extends Control


@export var modeButtons: Array[Button]
var called = false
@export var previousUI:Control
@export var volText:RichTextLabel
@export var volSlider:Slider

func _ready():
	for i in range(0,3):
		modeButtons[i].button_pressed = false
	called = true
	modeButtons[Controls.confirmSelect].button_pressed = true
	volText.text = "Volume: "+str(int(UserSettings.volume))
	volSlider.value = UserSettings.volume
	called = false


func volume_changed(vol):
	if called: return
	volText.text = "Volume: "+str(int(vol))
	UserSettings.volume = vol
	AudioServer.set_bus_volume_db(0,linear_to_db(lerpf(0,1,vol/100)))
	VisualTheme.instance.buttonPress.play()
	print(AudioServer.get_bus_volume_db(0))

func _change_confirm_mode(_toggle, mode):
	if called: return
	called = true
	VisualTheme.instance.buttonPress.play()
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
	VisualTheme.instance.buttonPress.play()

func back_button_pressed():
	VisualTheme.instance.buttonPress.play()
	exit_screen().tween_callback(previousUI.enter_screen)
