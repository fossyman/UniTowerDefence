@tool
extends Node3D
class_name TEST_ROTATOR

@export var RotateSpeedY:float
@export var RotateSpeedX:float
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(0.1 * RotateSpeedY)
	rotate_x(0.1 * RotateSpeedX)
	pass
