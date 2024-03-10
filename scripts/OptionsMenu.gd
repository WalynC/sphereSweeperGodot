extends Control


@export var modeButtons: Array[Button]
var called = false
@export var previousUI:Control
@export var volText:Label
@export var volSlider:Slider
@export var themeText:Label

func _ready():
	for i in range(0,3):
		modeButtons[i].button_pressed = false
	called = true
	modeButtons[Controls.confirmSelect].button_pressed = true
	volText.text = "Volume: "+str(int(UserSettings.volume))
	themeText.text = VisualLoader.instance.GetCurrentThemeName()
	volSlider.value = UserSettings.volume
	called = false

func playButtonSound():
	VisualTheme.instance.buttonPress.play()

func volume_changed(vol):
	volText.text = "Volume: "+str(int(vol))
	UserSettings.volume = vol
	AudioServer.set_bus_volume_db(0,linear_to_db(lerpf(0,1,vol/100)))
	if called: return

func _change_confirm_mode(_toggle, mode):
	Controls.confirmSelect = mode
	if called: return
	called = true
	VisualTheme.instance.buttonPress.play()
	for i in range(0,3):
		modeButtons[i].button_pressed = false
	modeButtons[mode].button_pressed = true
	if (TutorialMode.instance != null): TutorialMode.instance.UpdateText()
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
	playButtonSound()
	themeText.text = VisualLoader.instance.GetCurrentThemeName()

func back_button_pressed():
	playButtonSound()
	exit_screen().tween_callback(previousUI.enter_screen)
