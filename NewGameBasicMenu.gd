extends Control

@export var densities: Array[Button]
var called = false
# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func _change_density(toggle, density):
	if called: return
	called = true
	GameManager.density = density*5
	for i in range(0,3):
		densities[i].button_pressed = false
	densities[density].button_pressed = true
	called = false
