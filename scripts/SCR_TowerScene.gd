extends Node3D
class_name TowerScene

var Stats:Tower

@export var ProjectileSpawnPoint:Node3D

var Tickrate:float = 1
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
	Target = Get_ClosestEnemy(true)
	
	if Target:
		SpawnProjectile()
	pass
	
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
		return null
	
	var Closest:Node3D = GameplayController.instance.ActiveEnemies[0]
	
	for i in GameplayController.instance.ActiveEnemies.size():
		var Distance:float = global_position.distance_to(GameplayController.instance.ActiveEnemies[i].global_position)
		print(Distance)
		if UseRadius:
			print(Distance < Stats.Stats[1].Amount)
			if Distance < Stats.Stats[1].Amount:
				Closest = GameplayController.instance.ActiveEnemies[i]
			else:
				Closest = null
		else:
			Closest = GameplayController.instance.ActiveEnemies[i]

	return Closest
