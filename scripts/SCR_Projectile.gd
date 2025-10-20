extends Node3D
class_name ProjectileScene
@export var Speed:float = 1.0
@export var Damage:int = 1

func _Setup(_speed:float,_damage:int) -> void:
	Speed = _speed
	Damage = _damage

func _process(delta: float) -> void:
	global_position += -transform.basis.z * Speed * delta


func HitboxEntered(area: Area3D) -> void:
	if area is HurtboxComponent:
		area.HealthComponent.Damage(Damage)
		queue_free()
	pass # Replace with function body.
