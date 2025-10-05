@tool
extends PathFollow3D

@export var TravelSpeed:float = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	progress_ratio += TravelSpeed * delta
	pass
