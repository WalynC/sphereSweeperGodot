extends Control


@export var modeButtons: Array[Button]
var called = false
@export var previousUI:Control
@export var volText:Label
@export var volSlider:Slider
@export var themeText:Label
@export var uiTransition : UITransition
@export var changeButtons:Array[Button]

func _ready():
	set_deferred("size", get_parent_control().size*2)
	set_deferred("position", Vector2(0,get_parent_control().size.y))
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
	uiTransition.enter_screen()

func exit_screen():
	UserSettings.SaveOptionsMenuSettings()
	return uiTransition.exit_screen()

func change_theme_pressed(val):
	for i in changeButtons: i.disabled = true
	VisualLoader.instance.change_button_pressed(val)
	playButtonSound()
	themeText.text = VisualLoader.instance.GetCurrentThemeName()
	await get_tree().create_timer(.2).timeout
	for i in changeButtons: i.disabled = false

func back_button_pressed():
	playButtonSound()
	exit_screen().tween_callback(previousUI.enter_screen)
