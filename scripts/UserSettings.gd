extends Node
class_name UserSettings

const path = "user://settings.cfg"

static var config = ConfigFile.new()
static var volume = 50
# Called when the node enters the scene tree for the first time.
func _ready():
	print("load")
	var err = config.load(path)
	if (err != OK): SetDefaultSettings()
	GameManager.density = config.get_value("Settings", "density")
	GameManager.size = config.get_value("Settings", "size")
	GameManager.advDensity = config.get_value("Settings", "advDensity")
	GameManager.advSize = config.get_value("Settings", "advSize")
	Controls.confirmSelect = config.get_value("Settings", "confirmSelect")
	volume = config.get_value("Settings", "volume")
	GameUI.useMines = config.get_value("Settings", "useMines")
	GameUI.secondsOnly = config.get_value("Settings", "secondsOnly")
	VisualLoader.theme = config.get_value("Settings", "theme", 0)

static func SetDefaultSettings():
	config.set_value("Settings", "density", GameManager.density)
	config.set_value("Settings", "size", GameManager.size)
	config.set_value("Settings", "confirmSelect", Controls.confirmSelect)
	config.set_value("Settings", "volume", volume)
	config.set_value("Settings", "advDensity", GameManager.advDensity)
	config.set_value("Settings", "advSize", GameManager.advSize)
	config.set_value("Settings", "useMines", GameUI.useMines)
	config.set_value("Settings", "secondsOnly", GameUI.secondsOnly)
	config.set_value("Settings", "theme", VisualLoader.theme)

static func SaveBasicSettings():
	config.set_value("Settings", "density", GameManager.density)
	config.set_value("Settings", "size", GameManager.size)
	config.save(path)

static func SaveOptionsMenuSettings():
	config.set_value("Settings", "confirmSelect", Controls.confirmSelect)
	config.set_value("Settings", "volume", volume)
	config.set_value("Settings", "theme", VisualLoader.theme)
	config.save(path)
	
static func SaveCustomGameSettings():
	config.set_value("Settings", "advDensity", GameManager.advDensity)
	config.set_value("Settings", "advSize", GameManager.advSize)
	config.save(path)

static func SaveGameUISettings():
	config.set_value("Settings", "useMines", GameUI.useMines)
	config.set_value("Settings", "secondsOnly", GameUI.secondsOnly)
	config.save(path)
	