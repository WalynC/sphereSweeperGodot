extends Node3D

class_name GameManager

@export var mainMesh: MeshInstance3D
@export var iconMesh: MeshInstance3D
@export var glowMesh: MeshInstance3D
var board = Board.new()
var IconSphere = load("res://scripts/IconSphere.gd")
var isphere = IconSphere.new()
var iconSize

static var instance : GameManager

#pausing
var paused : bool = false

static var loading: bool

static var density := 10
static var size := 3
static var gameMode := 0
static var advDensity := 10
static var advSize := 3

static var gameRNG = RandomNumberGenerator.new()
static var visRNG = RandomNumberGenerator.new()

signal winEvent()
signal loseEvent()

@export var controls: Controls
@export var visLoad: VisualLoader
@export var worldPivot: Node3D
@export var controlBlocker : Control

@export var preset: Array[int]

# Called when the node enters the scene tree for the first time.
func _ready():
	instance = self
	board.gm = self
	isphere.gm = self
	visLoad.init()
	if (loading):
		SaveManager.newGame = false
		gameRNG.seed = SaveManager.saveData.gameSeed
		reset_visual_rng()
		board.subdiv = SaveManager.saveData.size
		board.percentMined = SaveManager.saveData.percentMined
		controls.pivot.basis = SaveManager.saveData.rot
		controls.cam.fov = SaveManager.saveData.zoom
	else:
		new_game()
	board._ready()
	visLoad.loadTheme()
	if (loading): board.LoadSave()
	if (preset.size() > 0):
		board.LoadPreset()

func _exit_tree():
	for i in board.triangles:
		i.clear()

func win():
	emit_signal("winEvent")
	VisualTheme.won()
	
func lose():
	controlBlocker.visible = true
	emit_signal("loseEvent")
	VisualTheme.lost()

func new_game(): #called from _ready if not loading save data
	if gameMode == 0: #basic
		board.subdiv = GameManager.size
		board.percentMined = GameManager.density
	elif gameMode == 1: #custom
		board.subdiv = GameManager.advSize
		board.percentMined = GameManager.advDensity
	else: #tutorial
		board.subdiv = 3
	SaveManager.saveData.gameSeed = Time.get_unix_time_from_system()
	SaveManager.saveData.visualSeed = SaveManager.saveData.gameSeed
	gameRNG.seed = SaveManager.saveData.gameSeed
	reset_visual_rng()
	SaveManager.saveData.percentMined = board.percentMined
	SaveManager.saveData.size = board.subdiv

func reset_visual_rng():
	visRNG.seed = SaveManager.saveData.visualSeed

func reset_game():
	reset_save_game()
	board.ResetBoard()
	paused = false

func reset_save_game():
	#retain visual seed and time
	var newData = SaveData.new()
	newData.visualTime = SaveManager.saveData.visualTime
	newData.visualSeed = SaveManager.saveData.visualSeed
	SaveManager.saveData = newData
	SaveManager.saveData.percentMined = board.percentMined
	SaveManager.saveData.size = board.subdiv
	#set seed
	SaveManager.saveData.gameSeed = Time.get_unix_time_from_system()
	reset_visual_rng()
	gameRNG.seed = SaveManager.saveData.gameSeed

var debug = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	board._process(delta)
	isphere._process(delta)
	
func update_mainMesh():
	mainMesh.mesh.clear_surfaces()
