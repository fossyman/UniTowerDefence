extends Node
class_name COMPONENT_HEALTH

signal Healed
signal Damaged
signal Death
signal HealthChanged

@export var Health:int = 100
@export var HealthCap:int = 100

func Damage(_amount:int):
	Health -= _amount
	if Health <= 0:
		Death.emit()
	else:
		Damaged.emit()
	HealthChanged.emit()
	pass
func Heal(_amount:int):
	Health += _amount
	Health = clamp(Health,0,HealthCap)
	Healed.emit()
	HealthChanged.emit()
	pass
func SetHealth(_amount:int):
	Health = _amount
	HealthChanged.emit()
	pass
