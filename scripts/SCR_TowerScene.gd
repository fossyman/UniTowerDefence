extends Node3D
class_name TowerScene

var Stats:Tower

@export var ProjectileSpawnPoint:Node3D

@export var Tickrate:float = 0.2
var TickAmt:float

var Target:Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	TickAmt += delta
	if TickAmt > Tickrate:
		TickAmt = 0.0
		Tick()

func Tick():
	print("1")
	Target = Get_ClosestEnemy(true)
	print("2")
	if Target:
		SpawnProjectile()
		print("3")
	else:
		print("4")
	pass
	print("5")
	
func SpawnProjectile():
	if Stats is DamageTower:
		var inst = Stats.ProjectileResource.Scene.instantiate() as Node3D
		ProjectileSpawnPoint.add_child(inst)
		inst.Speed = Stats.ProjectileResource.Speed
		inst.Damage =  Stats.ProjectileResource.Damage
		
		var dir = (Target.global_transform.origin - global_transform.origin)
		dir.y = 0
		dir = dir.normalized()
		var angle = atan2(-dir.x, -dir.z)
		inst.rotation.y = angle
	pass

func Get_ClosestEnemy(UseRadius:bool = false) -> Node3D:
	if GameplayController.instance.ActiveEnemies.is_empty():
		print("EMPTY")
		return null
	
	var Closest:Node3D = GameplayController.instance.ActiveEnemies[0]
	
	for i in GameplayController.instance.ActiveEnemies.size():
		var Distance:float = global_position.distance_to(GameplayController.instance.ActiveEnemies[i].global_position)
		if UseRadius:
			var RangeStatValue = Stats.GetCurrentAttackRange()
			if Distance < RangeStatValue:
				Closest = GameplayController.instance.ActiveEnemies[i]
				break
			else:
				Closest = null
		else:
			Closest = GameplayController.instance.ActiveEnemies[i]

	return Closest
