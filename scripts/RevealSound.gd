extends Node
class_name RevealSound

var timeBetweenSounds = .1
@export var sounds : Array[AudioStream]

static var sourcePool : Array[AudioStreamPlayer]
static var inUse : Array[AudioStreamPlayer]

static var nextSoundTime = 0.0
static var clearWavesRemaining = 0
static var topSound = 0
static var currentSound = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	sourcePool.clear()
	inUse.clear()
	var obj = AudioStreamPlayer.new()

static func Play(clearWaves, topClear):
	clearWavesRemaining = clearWaves
	topSound = topClear
	currentSound = topSound - clearWavesRemaining
	if (currentSound < 0): currentSound = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (inUse.size() > 0):
		var next = inUse[0]
		if (next.playing):
			#recycle audio object
			sourcePool.push_back(next)
			inUse.pop_front()
	if (clearWavesRemaining > 0 && nextSoundTime < Time.get_ticks_msec()):
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
		clearWavesRemaining-=1
		currentSound+=1
		if (currentSound == topSound): currentSound-=1
		
