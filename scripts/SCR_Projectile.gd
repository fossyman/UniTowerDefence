extends Node3D

var Speed:float
var Damage:int

func _process(delta: float) -> void:
	global_position += -transform.basis.z * Speed
