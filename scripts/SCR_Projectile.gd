extends Node3D

@export var Speed:float
@export var Damage:int

func _process(delta: float) -> void:
	global_position += -transform.basis.z * Speed


func HitboxEntered(area: Area3D) -> void:
	if area is HurtboxComponent:
		area.HealthComponent.Damage(Damage)
		queue_free()
	pass # Replace with function body.
