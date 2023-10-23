extends Node3D

class_name GameManager

@export var mainMesh: MeshInstance3D
@export var iconMesh: MeshInstance3D
var Board = load("res://Board.gd")
var board = Board.new()
var IconSphere = load("res://IconSphere.gd")
var isphere = IconSphere.new()
var iconSize

#pausing
var paused : bool = false:
	get:
		return paused
	set(value):
		paused = value
		emit_signal("toggle_game_paused", paused)
signal toggle_game_paused(is_paused : bool)

#saving
static var pathString := "user://saves/"
static var fileName := "save.json"
static var saveData: SaveData
static var loading: bool
static var seed = 0
static var visualSeed = 0

static var density := 10

var gameRNG = RandomNumberGenerator.new()
var visRNG = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	board.gm = self
	isphere.gm = self
	verify_save_directory(pathString)
	board._ready()
	if (loading):
		load_data()
		gameRNG.seed = saveData.seed
		visRNG.seed = saveData.visualSeed
	else:
		saveData = SaveData.new()
		saveData.seed = Time.get_unix_time_from_system()
		saveData.visualSeed = saveData.seed
		gameRNG.seed = saveData.seed
		visRNG.seed = saveData.visualSeed

func new_game():
	board.ResetBoard()
	new_save_game()

func new_save_game():
	var newGame = SaveData.new()
	#some data needs to be carried over
	newGame.timeBeforeFirstSelect += saveData.time + saveData.timeBeforeFirstSelect
	newGame.visualSeed = saveData.visualSeed
	saveData = newGame
	#setup data
	saveData.seed = Time.get_unix_time_from_system()

func verify_save_directory(path : String):
	DirAccess.make_dir_absolute(path)

func save_data():
	var path = pathString + fileName
	print(path)
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, "walyn is a winner")
	if file == null:
		print("err")
		print(FileAccess.get_open_error())
		return
	
	var data = JSON.stringify(saveData.ToData())
	print("data:" +data)
	file.store_string(data)
	file.close()

func load_data():
	var path = pathString + fileName
	if FileAccess.file_exists(path):
		var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, "walyn is a winner")
		if (file == null):
			print(FileAccess.get_open_error())
			return
		var content = file.get_as_text()
		file.close()
		var data = JSON.parse_string(content)
		if data == null:
			printerr("cannot parse %s as json_string: (%s)"%[path, content])
		else:
			print(data)
			saveData.LoadFromData(data)
			gameRNG.seed = saveData.seed
			visRNG.seed = saveData.visualSeed
			board.LoadSave()
	else:
		printerr("cannot open non-existent file at %s" %[path])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	board._process(delta)
	isphere._process(delta)
	
func update_mainMesh():
	mainMesh.mesh.clear_surfaces()

