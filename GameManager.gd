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

static var loading: bool
static var seed = 0
static var visualSeed = 0

static var density := 10
static var size := 3
static var gameMode := 0
static var advDensity := 10
static var advSize := 3

static var gameRNG = RandomNumberGenerator.new()
static var visRNG = RandomNumberGenerator.new()

signal winEvent()
signal loseEvent()

# Called when the node enters the scene tree for the first time.
func _ready():
	board.gm = self
	isphere.gm = self
	if (loading):
		gameRNG.seed = SaveManager.saveData.seed
		visRNG.seed = SaveManager.saveData.visualSeed
		board.subdiv = SaveManager.saveData.size
		board.percentMined = SaveManager.saveData.percentMined
	else:
		new_game()
	board._ready()

func win():
	emit_signal("winEvent")
func lose():
	emit_signal("loseEvent")

func new_game(): #called from _ready if not loading save data
	SaveManager.saveData = SaveData.new()
	if gameMode == 0: #basic
		board.subdiv = GameManager.size
		board.percentMined = GameManager.density
	elif gameMode == 1: #custom
		board.subdiv = GameManager.advSize
		board.percentMined = GameManager.advDensity
	else:
		board.subdiv = GameManager.advSize
		board.percentMined = GameManager.advDensity
	SaveManager.saveData.seed = Time.get_unix_time_from_system()
	SaveManager.saveData.visualSeed = SaveManager.saveData.seed
	gameRNG.seed = SaveManager.saveData.seed
	visRNG.seed = SaveManager.saveData.visualSeed
	SaveManager.saveData.percentMined = board.percentMined

func reset_game():
	reset_save_game()
	board.ResetBoard()

func reset_save_game():
	var newGame = SaveData.new()
	#some data needs to be carried over
	newGame.timeBeforeFirstSelect += SaveManager.saveData.time + SaveManager.saveData.timeBeforeFirstSelect
	newGame.visualSeed = SaveManager.saveData.visualSeed
	SaveManager.saveData = newGame
	#setup data
	SaveManager.saveData.seed = Time.get_unix_time_from_system()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	board._process(delta)
	isphere._process(delta)
	
func update_mainMesh():
	mainMesh.mesh.clear_surfaces()

