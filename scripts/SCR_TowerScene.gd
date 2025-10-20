extends Node3D
class_name TowerScene

var TowerResource:Tower

@export var ProjectileSpawnPoint:Node3D

@export var Tickrate:float = 1.0
var TickAmt:float

var _damage:float

var Target:Node3D

var TowerModifiers:Array[TowerModifier]

@export var LookAtTarget:bool = false

@export var LookAtNode:Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	refreshStats()
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
		if LookAtTarget:
			rotation.y = (global_position - Target.global_position).normalized().z

func SpawnProjectile():
	if TowerResource is DamageTower:
		var inst = TowerResource.ProjectileResource.Scene.instantiate() as ProjectileScene
		ProjectileSpawnPoint.add_child(inst)
		inst._Setup(TowerResource.ProjectileResource.Speed,TowerResource.GetCurrentAttackDamage())
		
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
			var RangeStatValue = TowerResource.GetCurrentAttackRange()
			if Distance < RangeStatValue:
				Closest = GameplayController.instance.ActiveEnemies[i]
				break
			else:
				Closest = null
		else:
			Closest = GameplayController.instance.ActiveEnemies[i]

	return Closest

func refreshStats():
	Tickrate = TowerResource.GetCurrentAttackSpeed()
	_damage = TowerResource.GetCurrentAttackDamage()
