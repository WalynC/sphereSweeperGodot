extends RichTextLabel
class_name ChainClearText

static var instance
var messageTime = 2.0
# Called when the node enters the scene tree for the first time.
func _ready():
	instance = self

func UpdateText(amt):
	text = str(amt) + " cleared!"
	Clear()

func Clear():
	await get_tree().create_timer(messageTime).timeout
	text = ""
