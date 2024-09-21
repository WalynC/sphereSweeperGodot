extends Node
class_name RevealSound

var timeBetweenSounds = .1
@export var sounds : Array[AudioStream]

static var sourcePool : Array[AudioStreamPlayer]
static var inUse : Array[AudioStreamPlayer]

static var nextSoundTime = 0.0
static var topSound = 0
static var currentSound = 0
static var numRequestingPlay = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	sourcePool.clear()
	inUse.clear()

static func Play(topClear):
	topSound = topClear
	currentSound = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (inUse.size() > 0):
		var next = inUse[0]
		if (next.playing):
			#recycle audio object
			sourcePool.push_back(next)
			inUse.pop_front()
	if (numRequestingPlay > 0 && nextSoundTime < Time.get_ticks_msec()):
		print("Play New Sound")
		nextSoundTime = Time.get_ticks_msec() + timeBetweenSounds * 1000
		if (sourcePool.size() == 0):
			#create new audio object
			var obj = AudioStreamPlayer.new()
			add_child(obj)
			sourcePool.push_back(obj)
		#get audio object and play sound
		var source = sourcePool.pop_front()
		source.stream = sounds[currentSound]
		source.play()
		if (currentSound < topSound): currentSound+=1
	if (numRequestingPlay <=0): 
		topSound = 0
		currentSound = 0
	#if (clearWavesRemaining == 0 && startTime > 0):
	#	print("Done playing sounds")
	#	print(str(Time.get_ticks_msec()-startTime))
	#	print("played: "+str(amountOfReveals))
	#	startTime = -1
