extends Node3D
class_name TowerScene

var Stats:Tower

var Tickrate:float = 1
var TickAmt:float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	TickAmt += delta
	if TickAmt > Tickrate:
		TickAmt = 0.0
		Tick()

func Tick():
	print("BANG")
	pass
